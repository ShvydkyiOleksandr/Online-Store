//
//  BasketViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 17.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor final class BasketViewModel: ObservableObject {
    @Published var basketProducts = [Product]()
    @Published var productsDict = [String: Int]()
    @Published var deliveryType: Order.DeliveryType = .novaPoshta
    @Published var paymentType: Order.PaymentType = .uponReceipt
    @Published var novaPoshtaNumber = ""
    @Published var street = ""
    @Published var building = ""
    @Published var apartment = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var selectedCity = User.Addresses.getCities().first!
    
    let isInPreview: Bool
    private(set) var isSaving = false
    
    private let db = Firestore.firestore()
    private var userEmail: String { isInPreview ? previewUser.email : Auth.auth().currentUser!.email! }
    private var userRef: DocumentReference { db.collection("users").document(userEmail) }
    private var productsDictRef: DocumentReference { userRef.collection("products").document("productsDict") }
    
    private lazy var paymentHandler = PaymentHandler()
    private lazy var ordersRef = db.collection("orders")
    private lazy var userOrdersRef = userRef.collection("orders")
    
    var isEmailValid: Bool { ValidationManager.isUserEmailValid(email: email) }
    var isPhoneNumberValid: Bool { ValidationManager.isPhoneNumberValid(phoneNumber: phoneNumber) }
    var isStreetValid: Bool { ValidationManager.isStreetValid(street: street, apartment: apartment, building: building) }
    var isApartmentValid: Bool { ValidationManager.isApartmentValid(street: street, apartment: apartment, building: building) }
    var isBuildingValid: Bool { ValidationManager.isBuildingValid(street: street, apartment: apartment, building: building) }
    var isFirstNameValid: Bool { ValidationManager.isFirstNameValid(firstName: firstName) }
    var isLastNameValid: Bool { ValidationManager.isLastNameValid(lastName: lastName) }
    var isCityNameValid: Bool { ValidationManager.isCityNameValid(cityName: selectedCity) }
    var isNovaPoshtaNumberValid: Bool { ValidationManager.isNovaPoshtaNumberValid(number: novaPoshtaNumber) }
    
    var sortedBasketProducts: [Product] { basketProducts.sorted() }
    var totalText: String { "\(badge ?? 0) item\((badge ?? 0) > 1 ? "s" : "") for \(String(format: "%.2f", total)) ₴" }
    
    var badge: Int? {
        let productsCount = productsDict.values.reduce(0, +)
        return productsCount == 0 ? nil : productsCount
    }
    
    var total: Double {
        var total: Double = 0
        
        basketProducts.forEach {
            guard let amount = productsDict[$0.id] else { return }
            for _ in 1...amount { total += $0.price }
        }
        
        return total
    }
    
    init(isInPreview: Bool = false) {
        self.isInPreview = isInPreview
        
        getProductsDict()
    }
    
    func basketButtonTapped(product: Product, alertManager: AlertManager) {
        Task {
            if isInBasket(product: product) {
                do {
                    try await removeFromBasket(product: product)
                } catch {
                    alertManager.show(error: error)
                }
            } else {
                do {
                    try await addToBasket(product: product, alertManager: alertManager)
                } catch {
                    alertManager.show(error: error)
                }
            }
        }
    }
    
    private func addToBasket(product: Product, alertManager: AlertManager) async throws {
        guard !isSaving else { return }
        try await increaseAmount(product: product, alertManger: alertManager)
        basketProducts.append(product)
    }
    
    private func removeFromBasket(product: Product) async throws {
        guard !isSaving else { return }
        guard let index = basketProducts.firstIndex(where: { $0.id == product.id }) else { return }
        var dict = productsDict
        dict[product.id] = nil
        
        do {
            try await saveProductsDict(dict: dict)
            basketProducts.remove(at: index)
        } catch {
            throw CustomError.deletingProductsFromBasket(error: error)
        }
    }
    
    func increaseAmount(product: Product, alertManger: AlertManager) async throws {
        guard !isSaving else { return }
        var dict = productsDict
        dict[product.id, default: 0] += 1
        try await saveProductsDict(dict: dict)
    }
    
    func decreaseAmount(product: Product, alertManager: AlertManager) {
        Task {
            guard !isSaving else { return }
            let id = product.id
            var dict = productsDict
    
            if dict[id, default: 0] > 1 {
                dict[id, default: 0] -= 1
                do {
                    try await saveProductsDict(dict: dict)
                } catch {
                    alertManager.show(error: error)
                }
            } else {
                do {
                    try await removeFromBasket(product: product)
                } catch {
                    alertManager.show(error: error)
                }
            }
        }
    }
    
    func isInBasket(product: Product) -> Bool {
        productsDict.keys.contains(where: { $0 == product.id })
    }
    
    func getOrderProducts(productsVM: ProductsViewModel) {
        basketProducts = productsVM.products.filter { productsDict.keys.contains($0.id) }
    }
    
    func getProductsDict() {
        Task {
            do {
                let document = try await productsDictRef.getDocument()
                do {
                    let fetchedProductsDict = try document.data(as: [String: Int].self)
                    productsDict = fetchedProductsDict
                } catch {
                    print("Error decoding products dictionary: \(error.localizedDescription)")
                }
            } catch {
                print("Error fetching products dictionary: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveProductsDict(dict: [String: Int]) async throws {
        guard !isSaving else { return }
        isSaving = true
        do {
            try await productsDictRef.setData(dict)
            productsDict = dict
            print("Products dictionary successfully updated!")
        } catch {
            print("Error saving products dictionary: \(error.localizedDescription)")
            throw CustomError.savingBasketProducts(error: error)
        }
        isSaving = false
    }
    
    func setupDefaultOrderInfo(user: User) {
        firstName = user.firstName
        lastName = user.lastName
        email = user.email
        phoneNumber = user.phone ?? ""
        street = user.addresses?.address?.street ?? ""
        apartment = user.addresses?.address?.apartment ?? ""
        building = user.addresses?.address?.building ?? ""
        selectedCity = user.addresses?.cityName ?? ""
        novaPoshtaNumber = user.addresses?.novaPoshtaNumber ?? ""
    }
    
    func makeOrder(isRepeatedOrder: Bool, alertManager: AlertManager) {
        Task {
            let content = basketProducts
                .map { $0.name }
                .enumerated()
                .reduce("") { $0 + "- " + $1.element + (basketProducts.count > $1.offset + 1 ? ";\n" : ".") }
            
            let order = Order(
                products: productsDict,
                receiver: Order.Receiver(
                    firstName: firstName,
                    lastName: lastName,
                    phone: phoneNumber,
                    email: email),
                deliveryType: deliveryType,
                paymentType: paymentType,
                cityName: selectedCity,
                content: content,
                total: totalText,
                novaPoshtaNumber: novaPoshtaNumber,
                address: User.Addresses.Address(
                    street: street,
                    building: building,
                    apartment: apartment))
            
            do {
                try ValidationManager.validateOrder(order: order)
                
                if paymentType == .withCredit {
                    do {
                        try await pay(order: order, isRepeatedOrder: isRepeatedOrder)
                        alertManager.showSuccesfulOrder()
                    } catch {
                        alertManager.show(error: error)
                    }
                } else {
                    do {
                        try await finishOrder(order: order, isRepeatedOrder: isRepeatedOrder)
                        alertManager.showSuccesfulOrder()
                    } catch {
                        alertManager.show(error: error)
                    }
                }
            } catch {
                alertManager.show(error: error)
            }
    }
}
    
    private func finishOrder(order: Order, isRepeatedOrder: Bool) async throws {
        try await addOrderToFirebase(order: order)
        basketProducts = []
        productsDict = [:]
        if !isRepeatedOrder { try await saveProductsDict(dict: productsDict) }
    }
    
    private func pay(order: Order, isRepeatedOrder: Bool) async throws {
        try await startPayment(total: total, order: order)
        try await finishOrder(order: order, isRepeatedOrder: isRepeatedOrder)
    }
    
    private func startPayment(total: Double, order: Order) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            paymentHandler.startPayment(products: basketProducts, total: total) { success in
                guard success else { continuation.resume(throwing: CustomError.paymentError); return }
                continuation.resume()
            }
        }
    }
    
    private func addOrderToFirebase(order: Order) async throws {
        try await addOrderToOrders(order: order)
        do {
            try await userOrdersRef.document(order.id).setData([:])
        } catch {
            let error = CustomError.addingOrder(error: error)
            print("Error uploading order to user orders in firebase: \(error.description)")
            throw error
        }
    }

    private func addOrderToOrders(order: Order) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try ordersRef.document(order.id).setData(from: order)
                continuation.resume()
            } catch {
                let error = CustomError.addingOrder(error: error)
                print("Error adding order to orders in firebase: \(error.description)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func repeatOrder(productsVM: ProductsViewModel, order: Order) {
        firstName = order.receiver.firstName
        lastName = order.receiver.lastName
        phoneNumber = order.receiver.phone
        email = order.receiver.email
        selectedCity = order.cityName
        deliveryType = order.deliveryType
        paymentType = order.paymentType
        novaPoshtaNumber = order.novaPoshtaNumber ?? ""
        building = order.address?.building ?? ""
        street = order.address?.street ?? ""
        apartment = order.address?.apartment ?? ""
        productsDict = order.products
        
        var products = [Product]()
        
        for id in productsDict.keys {
            guard let product = productsVM.products.first(where: { $0.id == id }) else { continue }
            products.append(product)
        }
        
        basketProducts = products
    }
}
