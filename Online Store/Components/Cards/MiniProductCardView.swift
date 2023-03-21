//
//  MiniProductCardView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct MiniProductCardView: View {
    @EnvironmentObject private var basketVM: BasketViewModel
    @EnvironmentObject private var productsVM: ProductsViewModel
    @EnvironmentObject private var alertManager: AlertManager
    @Binding var selectedProduct: Product?
    let product: Product
    private var isInBasket: Bool { basketVM.isInBasket(product: product) }
    private var isAvailable: Bool { productsVM.isAvailable(product: product) }
    
    var sportName = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(product.name)
                .padding(.bottom, 5)
                .font(.body.bold())
                .lineLimit(2)
            
            CachedAsyncImage(url: product.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView().padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(product.price.formatted(.currency(code: "UAH")))
                    
                    Text(isAvailable ? "Available" : "Unavailable")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    basketVM.basketButtonTapped(product: product, alertManager: alertManager)
                } label: {
                    Image(systemName: "basket")
                        .border(padding: 5)
                        .foregroundColor(isInBasket ? .green : .gray)
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 5)
            
            BlackButton(buttonName: "Detail") { selectedProduct = product }
        }
        .border(padding: 10)
        .animation(.default, value: isInBasket)
    }
}

struct MiniProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        MiniProductCardView(selectedProduct: .constant(previewProduct), product: previewProduct)
            .environmentObject(BasketViewModel(isInPreview: true))
            .environmentObject(ProductsViewModel(isInPreview: true))
            .environmentObject(AlertManager())
            .frame(maxWidth: 200, maxHeight: 350)
    }
}
