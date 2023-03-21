//
//  MainView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var productsVM: ProductsViewModel
    @ObservedObject var brandsVM: BrandsViewModel
    @State private var selectedBrand: Brand?
    private let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Brands")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(columns: columns) {
                    ForEach(brandsVM.filteredBrands) { brand in
                        BrandItem(brand: brand)
                            .contentShape(Rectangle())
                            .fullScreenCover(item: $selectedBrand) { CatalogView(brand: $0) }
                            .onTapGesture {
                                selectedBrand = brand
                                productsVM.brand = brand
                                productsVM.selectedType = .none
                            }
                    }
                }
            }
            .searchable(text: $brandsVM.searchText, prompt: "Enter brand name")
            .animation(.default, value: brandsVM.searchText)
            .background(Color("background"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal, 5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    LogoView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .overlay {
                            MobButton()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(brandsVM: BrandsViewModel())
            .environmentObject(ProductsViewModel(isInPreview: true))
            .environmentObject(BasketViewModel(isInPreview: true))
            .environmentObject(ProceduresViewModel())
    }
}
