//
//  UserBasket.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct UserBasket: View {
    @EnvironmentObject private var basketVM: BasketViewModel
    @EnvironmentObject private var productsVM: ProductsViewModel
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var alertManager: AlertManager
    @State private var selectedProduct: Product?
    @State private var showProducts = false
    @State private var showPicker = false
    @FocusState private var focusedField: FocusedField?
    let shownFromOrdersView: Bool
    
    init(shownFromOrdersView: Bool = false) {
        self.shownFromOrdersView = shownFromOrdersView
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if showProducts && !basketVM.sortedBasketProducts.isEmpty {
                    VStack {
                        showProductsButton
                        
                        ForEach(basketVM.sortedBasketProducts) { product in
                            MiniCardOrderView(selectedProduct: $selectedProduct, product: product)
                                .fullScreenCover(item: $selectedProduct) { product in
                                    ProductView(product: product)
                                }
                        }
                    }
                    .border(padding: 5)
                } else {
                    showProductsButton
                }
                
                ReceiverView(focusedField: _focusedField)
                
                ChooseDeliveryView(focusedField: _focusedField, showPicker: $showPicker)
                
                ChoosePaymentView()
                
                if basketVM.paymentType == .withCredit {
                    PaymentButton {
                        basketVM.makeOrder(isRepeatedOrder: shownFromOrdersView, alertManager: alertManager)
                    }
                } else {
                    BlackButton(buttonName: "Checkout".uppercased()) {
                        basketVM.makeOrder(isRepeatedOrder: shownFromOrdersView, alertManager: alertManager)
                    }
                }
                
                Spacer(minLength: 50)
            }
            .padding(.horizontal, 5)
            .animation(.default, value: basketVM.sortedBasketProducts)
            .animation(.spring(), value: showProducts)
            .customPicker(
                show: $showPicker,
                selection: $basketVM.selectedCity,
                data: User.Addresses.getCities()
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color("background"))
            .toolbar {
                ToolbarItem(placement: .principal) { Text("Basket").font(.title2.bold()) }
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
                
                ToolbarItemGroup(placement: .keyboard) {
                    KeyboardToolbar(focusedField: _focusedField, viewType: .userBasket)
                }
            }
            .onAppear {
                if !shownFromOrdersView {
                    basketVM.setupDefaultOrderInfo(user: authManager.currentUser)
                    basketVM.getOrderProducts(productsVM: productsVM)
                }
            }
            .onDisappear { if shownFromOrdersView { basketVM.getProductsDict() } }
        }
    }
    
    var showProductsButton: some View {
        DiscloseListButton(
            show: $showProducts,
            isListEmpty: basketVM.sortedBasketProducts.isEmpty,
            title: basketVM.totalText,
            titleForEmptyList: "Basket is empty"
        )
    }
}

struct UserBasket_Previews: PreviewProvider {
    static var authManager: AuthManager {
        let manager = AuthManager()
        manager.currentUser = previewUser
        return manager
    }
    
    static var previews: some View {
        UserBasket()
            .environmentObject(BasketViewModel(isInPreview: true))
            .environmentObject(ProductsViewModel(isInPreview: true))
            .environmentObject(authManager)
            .environmentObject(AlertManager())
    }
}
