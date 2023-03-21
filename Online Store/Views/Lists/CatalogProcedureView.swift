//
//  CatalogProcedureView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct CatalogProcedureView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var proceduresVM: ProceduresViewModel
    @State private var selectedProcedure: Procedure?
    let brand: Brand
    private let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            Group {
                if proceduresVM.filteredProcedures.isEmpty {
                    Text("There are not procedures for  \(brand.name) brand")
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns) {
                            ForEach(proceduresVM.filteredProcedures) { procedure in
                                ProcedureMiniCard(selectedProcedure: $selectedProcedure, procedure: procedure)
                                    .fullScreenCover(item: $selectedProcedure, content: { procedure in
                                        ProcedureView(procedure: procedure)
                                    })
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                }
            }
            .onAppear { proceduresVM.brand = brand }
            .animation(.default, value: proceduresVM.searchText)
            .searchable(text: $proceduresVM.searchText, prompt: "Enter procedure name")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { dismiss() }
                        .frame(width: 80)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Procedures")
                        .font(.title2.bold())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CatalogProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogProcedureView(brand: previewBrand)
            .environmentObject(ProductsViewModel(isInPreview: true))
            .environmentObject(ProceduresViewModel())
    }
}
