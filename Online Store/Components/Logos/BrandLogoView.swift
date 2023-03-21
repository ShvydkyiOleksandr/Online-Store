//
//  BrandLogoView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct BrandLogoView: View {
    let brand: Brand
    
    var body: some View {
        CachedAsyncImage(url: brand.imageUrl) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView().padding()
        }
        .frame(minHeight: 150)
    }
}

struct BrandLogoView_Previews: PreviewProvider {
    static var previews: some View {
        BrandLogoView(brand: previewBrand)
            .padding()
    }
}
