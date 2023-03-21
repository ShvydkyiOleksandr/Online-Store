//
//  LikeView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct LikeView: View {
    @EnvironmentObject private var productsVM: ProductsViewModel
    @State private var selectedProduct: Product?
    private let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            Group {
                if productsVM.likedProducts.isEmpty {
                    Text("There are not liked products yet")
                        .font(.title2)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(productsVM.likedProducts) { likedProduct in
                                MiniProductCardView(selectedProduct: $selectedProduct, product: likedProduct)
                                    .fullScreenCover(item: $selectedProduct) { product in
                                        ProductView(product: likedProduct)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color("background"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favorites")
                        .font(.title2.bold())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
            }
        }
    }
}

struct LikeView_Previews: PreviewProvider {
    static var previews: some View {
        LikeView()
            .environmentObject(ProductsViewModel(isInPreview: true))
            .environmentObject(BasketViewModel(isInPreview: true))
    }
}
