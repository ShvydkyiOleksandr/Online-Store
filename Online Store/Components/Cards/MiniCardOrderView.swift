//
//  MiniCardOrderView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct MiniCardOrderView: View {
    @EnvironmentObject private var basketVM: BasketViewModel
    @EnvironmentObject private var alertManager: AlertManager
    @Binding var selectedProduct: Product?
    let product: Product
    private var amount: String { basketVM.productsDict[product.id]?.formatted() ?? "1" }
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: product.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                ProgressView().padding()
            }
            .frame(height: 105)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(product.name)
                    .font(.body.bold())
                
                HStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        Text("**Volume:** \(product.volume.formatted()) ml")
                        
                        Text("**Amount:** \(amount)")
                        
                        Text(product.price.formatted(.currency(code: "UAH")))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    stepper
                }
            }
        }
        .onTapGesture { selectedProduct = product }
        .border(padding: 10)
    }
    
    var stepper: some View {
        HStack {
            Button {
                basketVM.decreaseAmount(product: product, alertManager: alertManager)
            } label: {
                Image(systemName: "minus")
                    .font(.title.bold())
            }
            
            Divider()
            
            Button {
                Task {
                    do {
                        try await basketVM.increaseAmount(product: product, alertManger: alertManager)
                    } catch {
                        alertManager.show(error: error)
                    }
                }
            } label: {
                Image(systemName: "plus")
                    .font(.title.bold())
            }
        }
        .padding(.horizontal, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
                .shadow(radius: 5)
        }
        .frame(maxHeight: 40)
    }
}

struct MiniCardOrderView_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardOrderView(selectedProduct: .constant(previewProduct), product: previewProduct)
            .environmentObject(BasketViewModel(isInPreview: true))
            .environmentObject(AlertManager())
    }
}
