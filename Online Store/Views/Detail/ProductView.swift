//
//  ProductView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct ProductView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var productsVM: ProductsViewModel
    @EnvironmentObject private var alertManager: AlertManager
    @State private var descriptionExpanded = false
    @State private var selectedSuggestionProduct: Product?
    @State private var selectedVolume: Int
    let product: Product
    private var productForVolume: Product { productsVM.getProductForVolume(product: product, volume: selectedVolume)}
    private var isLiked: Bool {productsVM.isLiked(product: productForVolume)}
    private var isAvailable: Bool{productsVM.isAvailable(product: productForVolume)}
    
    init(product: Product) {
        self.product = product
        _selectedVolume = State(wrappedValue: product.volume)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack(alignment: .leading) {
                        productCard
                        
                        Divider()
                        
                        Text("Buy with it")
                            .font(.title3.bold())
                    }
                    .padding([.horizontal, .top])
                    
                    SuggestionProductsView(selectedSuggestionProduct: $selectedSuggestionProduct,
                                           product: productForVolume)
                        .frame(maxHeight: 250)
                        .fullScreenCover(item: $selectedSuggestionProduct) { product in
                            ProductView(product: product)
                        }
                }
            }
            .animation(.default, value: isLiked)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { dismiss() }.frame(width: 80)
                }
                
                ToolbarItem(placement: .principal) { Text(product.name).font(.title2.bold()) }
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var productCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            CachedAsyncImage(url: productForVolume.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
            } placeholder: {
                ProgressView().padding()
            }
            
            Text(productForVolume.name)
                .font(.title2)
            
            Divider()
            
            Text("**Article:** \(productForVolume.article)")
            
            Divider()
            
            HStack {
                Text("**Volume (ml):**")
                
                if product.allVolumes.count > 1 {
                    Picker("Volume (ml)", selection: $selectedVolume) {
                        ForEach(Array(productForVolume.allVolumes.keys.sorted()), id: \.self) { volume in
                            Text(String(volume))
                        }
                    }
                    .pickerStyle(.segmented)
                } else {
                    Text(product.volume.formatted())
                }
            }
            
            Divider()
            
            Text(isAvailable ? "Available" : "Unavailable")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay {
                    Button {
                        productsVM.likeButtonTapped(product: productForVolume, alertManager: alertManager)
                    } label: {
                        Label {
                            Text(isLiked ? "Remove from liked" : "Add to liked")
                                .bold()
                                .padding(.trailing, 10)
                        } icon: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(isLiked ? .red: .gray)
                                .font(.title3)
                        }
                        .padding(5)
                        .border()
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            
            Divider()
            
            Group {
                HStack {
                    Text("**Description**:")
                    Text("(Tap here to see more)")
                        .frame(maxWidth: .infinity)
                        .onTapGesture { descriptionExpanded.toggle() }
                }
                
                Text(productForVolume.formattedDescription)
                    .if(!descriptionExpanded) { $0.lineLimit(2) }
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: previewProduct)
            .environmentObject(ProductsViewModel(isInPreview: true))
            .environmentObject(AlertManager())
    }
}
