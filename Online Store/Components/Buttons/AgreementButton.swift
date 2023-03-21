//
//  AgreementButton.swift
//  Online Store
//
//  Created by Олександр Швидкий on 13.01.2023.
//

import SwiftUI

struct AgreementButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isAgree: Bool
    
    var body: some View {
        Button {
            withAnimation { isAgree.toggle() }
        } label: {
            HStack {
                Label("checkmark", systemImage: "checkmark")
                    .foregroundColor(isAgree ? .green : (colorScheme == .light ? .black.opacity(0.3) : .white.opacity(0.3)))
                    .labelStyle(.iconOnly)
                    .font(.system(size: 40).bold())
                    .padding()
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 2)
                    .frame(maxHeight: 70)
                
                Spacer()
                
                Text("Agreement with the offer agreement")
                    .font(.title3)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .border()
        }
    }
}

struct AgreementButton_Previews: PreviewProvider {
    static var previews: some View {
        AgreementButton(isAgree: .constant(true))
    }
}
