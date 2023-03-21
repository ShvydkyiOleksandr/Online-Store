//
//  WhiteButton.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct WhiteButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let buttonName: String
    var isBoldTitle: Bool? = nil
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonName)
                .if(isBoldTitle != nil) { $0.bold() }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(colorScheme == .light ? .black : .white)
                .border()
        }
        .buttonStyle(.plain)
    }
}

struct WhiteButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WhiteButton(buttonName: "ButtonName", action: {})
            WhiteButton(buttonName: "ButtonName", isBoldTitle: true, action: {})
        }
    }
}
