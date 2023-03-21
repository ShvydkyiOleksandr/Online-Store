//
//  OrderCardView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

struct OrderCardView: View {
    @EnvironmentObject private var basketVM: BasketViewModel
    @EnvironmentObject private var productsVM: ProductsViewModel
    @State private var showUserBasket = false
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading) {
                Text("Order content:")
                    .font(.body.bold())
                
                Text(order.content)
                    .padding(.leading, 20)
            }
            
            Text("**Total:** \(order.total)")
            
            Text("**Status:** \(order.statusString)")
            
            Text("**Date:** \(order.formattedDate)")
            
            BlackButton(buttonName: "Repeat order") {
                basketVM.repeatOrder(productsVM: productsVM, order: order)
                showUserBasket = true
            }
            .sheet(isPresented: $showUserBasket) { UserBasket(shownFromOrdersView: true) }
        }
        .border(radius: 20, padding: 10)
    }
}

struct OrderCardView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCardView(order: previewOrder)
            .environmentObject(BasketViewModel(isInPreview: true))
            .environmentObject(ProductsViewModel(isInPreview: true))
    }
}
