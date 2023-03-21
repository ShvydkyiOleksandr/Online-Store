//
//  BlackBorder.swift
//  Online Store
//
//  Created by Олександр Швидкий on 13.01.2023.
//

import SwiftUI

extension View {
    func border(lineWidth: CGFloat = 2, radius: CGFloat = 30, padding: CGFloat = 0, shadowRadius: CGFloat = 2, color: Color = .gray) -> some View {
        return self
            .padding(padding)
            .overlay { RoundedRectangle(cornerRadius: radius, style: .continuous).stroke(color, lineWidth: lineWidth)}
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(radius: shadowRadius)
            .padding(2)
    }
}
