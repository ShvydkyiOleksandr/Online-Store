//
//  CatalogView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct CatalogView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var productsVM: ProductsViewModel
    @EnvironmentObject private var proceduresVM: ProceduresViewModel
    @State private var selectedProduct: Product?
    @State private var showProcedures = false
    private let columns = [GridItem(.adaptive(minimum: 150))]
    let brand: Brand
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                Picker("Product type", selection: $productsVM.selectedType) {
                    ForEach(Product.ProductType.allCases[brand.name == "Brae" ? (2...6) : 0...2]) {
                        Text($0.rawValue)
                    }
                }
                
                LazyVGrid(columns: columns) {
                    ForEach(productsVM.filteredProducts) { product in
                        MiniProductCardView(selectedProduct: $selectedProduct, product: product)
                            .fullScreenCover(item: $selectedProduct, content: { product in
                                ProductView(product: product)
                            })
                    }
                }
            }
            .searchable(text: $productsVM.searchText, prompt: "Enter product name")
            .animation(.default, value: productsVM.searchText)
            .animation(.default, value: productsVM.filteredProducts)
            .padding(.horizontal, 5)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { dismiss() }
                        .frame(width: 100)
                }
                
                ToolbarItem(placement: .principal) { Text(brand.name).font(.title2.bold()) }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showProcedures.toggle()
                    } label: {
                        Label("info", systemImage: "info.circle")
                            .labelStyle(.iconOnly)
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .fullScreenCover(isPresented: $showProcedures) {
                        CatalogProcedureView(brand: brand)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var productsVM: ProductsViewModel {
        let vm = ProductsViewModel(isInPreview: true)
        vm.brand = previewBrand
        return vm
    }
    
    static var previews: some View {
        CatalogView(brand: previewBrand)
            .environmentObject(productsVM)
            .environmentObject(BasketViewModel(isInPreview: true))
            .environmentObject(ProceduresViewModel())
    }
}
