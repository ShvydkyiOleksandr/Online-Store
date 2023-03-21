//
//  ProductsViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 17.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor final class ProductsViewModel: ObservableObject {
    @Published private(set) var products = [Product]()
    @Published private(set) var likedProductsIDs = [String]()
    @Published private(set) var availabilityList = [String: Int]()
    @Published var selectedType: Product.ProductType = .none
    @Published var searchText = ""
    
    let isInPreview: Bool
    
    private let db = Firestore.firestore()
    private var userEmail: String { isInPreview ? previewUser.email : Auth.auth().currentUser!.email! }
    private var userRef: DocumentReference { db.collection("users").document(userEmail) }
    private var likedProductsRef: CollectionReference { userRef.collection("likedProductsCollection") }
    var productsRef: CollectionReference { db.collection("products") }
    var availabilityListRef: DocumentReference { db.collection("productsInfo").document("availabilityList") }
    
    var brand: Brand?
    
    var likedProducts: [Product] {
        products.filter { product in likedProductsIDs.contains(where: { $0 == product.id }) }
    }
    
    var filteredProducts: [Product] {
        let brandProducts = products.filter { $0.brand == brand?.name }
        
        if selectedType == .none {
            if searchText.isEmpty {
                return brandProducts
            } else {
                return brandProducts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        } else {
            if searchText.isEmpty {
                return brandProducts.filter { $0.type == selectedType }
            } else {
                return brandProducts.filter { $0.type == selectedType && $0.name.lowercased().contains(searchText.lowercased())}
            }
        }
    }
    
    var badge: Int? {
        let count = likedProductsIDs.count
        return count == 0 ? nil : count
    }
    
    init(isInPreview: Bool = false) {
        self.isInPreview = isInPreview
        
        getProducts()
        getLikedProductsIds()
        getAvailabilityList()
    }
    
    func getSuggestionProducts(product: Product) -> [Product] {
        products.filter { $0.id != product.id && $0.type == product.type }
    }
    
    private func getAvailabilityList() {
        availabilityListRef.addSnapshotListener { querySnapshot, error in
            if let error {
                print("Error fetching availability list: \(error.localizedDescription))")
            } else {
                guard let querySnapshot else { return }
                do {
                    let fetchedAvailabilityList = try querySnapshot.data(as: [String: Int].self)
                    self.availabilityList = fetchedAvailabilityList
                    print("availabilityList loaded")
                } catch {
                    print("Error decoding availability list: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getProductForVolume(product: Product, volume: Int) -> Product {
        guard product.id != product.allVolumes[volume] else { return  product}
        return products.first(where: { $0.id == product.allVolumes[volume] }) ?? product
    }
    
    private func getProducts() {
        Task {
            do {
                let documents = try await productsRef.getDocuments().documents
                
                products = documents.compactMap {
                    do {
                        return try $0.data(as: Product.self)
                    } catch {
                        print("Error decoding document into Product: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                print("Products loaded")
            } catch {
                print("Error fetching products: \(error.localizedDescription)")
            }
        }
    }
    
    private func getLikedProductsIds() {
        Task {
            do {
                let documents = try await likedProductsRef.getDocuments().documents
                let likedProductsIds = documents.map { $0.documentID }
                self.likedProductsIDs = likedProductsIds
                print("likedProductsIds loaded")
            } catch {
                print("Error fetching likedProductsIds: \(error.localizedDescription)")
            }
        }
    }
    
    func likeButtonTapped(product: Product, alertManager: AlertManager) {
        Task {
            if isLiked(product: product) {
                do {
                    try await deleteFromLikedProducts(product: product)
                } catch {
                    alertManager.show(error: error)
                }
            } else {
                do {
                    try await addToLikedProducts(product: product)
                } catch {
                    alertManager.show(error: error)
                }
            }
        }
    }
    
    private func addToLikedProducts(product: Product) async throws {
        let id = product.id
        do {
            try await likedProductsRef.document(id).setData([:])
            likedProductsIDs.append(id)
            print("Product with id: \(id) added to likedProducts")
        } catch {
            throw CustomError.addingToLikedProducts(error: error)
        }
    }
    
    private func deleteFromLikedProducts(product: Product) async throws {
        let id = product.id
        guard let index = likedProductsIDs.firstIndex(where: { $0 == id }) else { return }
        do {
            try await likedProductsRef.document(id).delete()
            likedProductsIDs.remove(at: index)
            print("Product with id: \(id) deleted from liked products")
        } catch {
            throw CustomError.deletingFromLikedProducts(error: error)
        }
    }
    
    func isLiked(product: Product) -> Bool {
        likedProducts.contains(where: { $0.id == product.id })
    }
    
    func isAvailable(product: Product) -> Bool {
        availabilityList[product.id] ?? 0 > 0
    }
}
 
