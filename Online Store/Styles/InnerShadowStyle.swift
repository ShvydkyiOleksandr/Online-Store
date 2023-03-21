//
//  BorderedTextField.swift
//  Online Store
//
//  Created by Олександр Швидкий on 19.01.2023.
//

import SwiftUI

struct InnerShadowStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var isCorrect: Bool?
    var foregroundColor: Color { colorScheme == .light ? Color(red: 236/255, green: 234/255, blue: 235/255) : .gray }
    var shadowColor = Color(red: 197/255, green: 197/255, blue: 197/255)
    
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(.accentColor)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        .shadow(.inner(color: shadowColor, radius: 2, x: 2, y: 2))
                        .shadow(.inner(color: colorScheme == .light ? .white : .gray, radius: 2, x: -2, y: -2))
                    )
                    .foregroundColor(foregroundColor)
                    .if(isCorrect != nil) { $0.isCorrectShadow(isCorrect: isCorrect!) }
            )
    }
}

extension View {
    func innerShadowStyle(isCorrect: Bool? = nil) -> some View {
        modifier(InnerShadowStyle(isCorrect: isCorrect))
    }
}
