//
//  OrdersView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct OrdersView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var ordersVM: OrdersViewModel
    @State private var showCompletedOrders = false
    @State private var showProcessingOrders = false
    
    var body: some View {
        NavigationView {
            Group {
                if ordersVM.userOrders.isEmpty {
                    Text("There are no orders yet").font(.title)
                } else {
                    ScrollView {
                        if !ordersVM.processingOrders.isEmpty {
                            VStack {
                                showProcessingOrdersButton
                                
                                if showProcessingOrders {
                                    ForEach(ordersVM.processingOrders) { OrderCardView(order: $0) }
                                }
                            }
                            .if(showProcessingOrders) { $0.border(padding: 5) }
                            .animation(.spring(), value: showCompletedOrders)
                        }
                        
                        if !ordersVM.completedOrders.isEmpty {
                            VStack {
                                showCompletedOrdersButton
                                
                                if showCompletedOrders {
                                    ForEach(ordersVM.completedOrders) { OrderCardView(order: $0) }
                                }
                            }
                            .if(showCompletedOrders) { $0.border(padding: 5) }
                            .animation(.spring(), value: showProcessingOrders)
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .onAppear { ordersVM.getUserOrders() }
            .refreshable { ordersVM.getUserOrders() }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { dismiss() }.frame(width: 80)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Orders")
                        .font(.title2.bold())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var showCompletedOrdersButton: some View {
        DiscloseListButton(
            show: $showCompletedOrders,
            isListEmpty: ordersVM.completedOrders.isEmpty,
            title: "Completed Orders",
            titleForEmptyList: "Completed Orders is empty"
        )
    }
    
    var showProcessingOrdersButton: some View {
        DiscloseListButton(
            show: $showProcessingOrders,
            isListEmpty: ordersVM.processingOrders.isEmpty,
            title: "Processing Orders",
            titleForEmptyList: "Processing Orders is empty"
        )
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
            .environmentObject(OrdersViewModel(isInPreview: true))
    }
}


