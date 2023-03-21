//
//  IsCorrectShadow.swift
//  Online Store
//
//  Created by Олександр Швидкий on 06.02.2023.
//

import SwiftUI

struct IsCorrectShadow: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var isCorrect: Bool
    
    func body(content: Content) -> some View {
        content
            .if(!isCorrect) { $0.shadow(color: .red, radius: 3) }
            .if(!isCorrect && colorScheme == .dark) { $0.shadow(color: .red, radius: 3) }
    }
}

extension View {
    func isCorrectShadow(isCorrect: Bool) -> some View {
        modifier(IsCorrectShadow(isCorrect: isCorrect))
    }
}
