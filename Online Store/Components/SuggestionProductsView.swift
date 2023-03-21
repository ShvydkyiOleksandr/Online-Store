//
//  SuggestionProductsView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct SuggestionProductsView: View {
    @EnvironmentObject private var productsVM: ProductsViewModel
    @Binding var selectedSuggestionProduct: Product?
    @State private var scrollViewContentSize: CGSize = .zero
    let product: Product
    
    private var suggestionProducts: [Product] { productsVM.getSuggestionProducts(product: product) }
    private var isAvailable: Bool { productsVM.isAvailable(product: product) }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(suggestionProducts) { suggestionProduct in
                        VStack {
                            VStack(alignment: .leading, spacing: 0) {
                                CachedAsyncImage(url: suggestionProduct.imageUrl) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding(.bottom, 5)
                                } placeholder: {
                                    ProgressView().padding()
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                VStack(alignment: .leading) {
                                    Text(suggestionProduct.name)
                                        .padding(.bottom, 1)
                                        .lineLimit(2)
                                    
                                    Text(suggestionProduct.price.formatted(.currency(code: "UAH")))
                                    
                                    Text(isAvailable ? "Available" : "Unavailable" )
                                }
                            }
                            .border(padding: 10)
                            .frame(maxWidth: 150)
                            .onTapGesture { selectedSuggestionProduct = suggestionProduct }
                        }
                    }
                }
                .padding(.leading)
            }
        }
    }
}

struct SuggestionProductsView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionProductsView(
            selectedSuggestionProduct: .constant(previewProduct),
            product: previewProduct
        )
        .environmentObject(ProductsViewModel(isInPreview: true))
    }
}
