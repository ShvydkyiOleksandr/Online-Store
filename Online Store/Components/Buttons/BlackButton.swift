//
//  GrayButton.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct BlackButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let buttonName: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(buttonName)
                .font(.title3)
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(colorScheme == .light ? Color.black : Color.white)
                }
                .border(color: colorScheme == .light ? Color.black : Color.white)
        }
        .buttonStyle(.plain)
    }
}

struct GrayButton_Previews: PreviewProvider {
    static var previews: some View {
        BlackButton(buttonName: "Button name") {}
    }
}
