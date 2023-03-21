//
//  BrandItem.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct BrandItem: View {
    let brand: Brand
    
    var body: some View {
        VStack {
            Text(brand.name)
                .font(.title3.bold())
            
            Spacer()
            
            BrandLogoView(brand: brand)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .border()
        .frame(maxHeight: .infinity)
    }
}

struct BrandItem_Previews: PreviewProvider {
    static var previews: some View {
        BrandItem(brand: previewBrand)
    }
}
