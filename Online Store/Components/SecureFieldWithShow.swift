//
//  SecureFieldWithShow.swift
//  Online Store
//
//  Created by Олександр Швидкий on 14.03.2023.
//

import SwiftUI

struct SecureFieldWithShow: View {
    var prompt: String
    @Binding var text: String
    @Binding var show: Bool
    
    init(_ prompt: String, text: Binding<String>, show: Binding<Bool>) {
        self.prompt = prompt
        _text = Binding(projectedValue: text)
        _show = Binding(projectedValue: show)
    }
    
    var body: some View {
        HStack {
            TextField(prompt, text: $text)
                .opacity(show ? 1 : 0)
                .overlay {
                    SecureField(prompt, text: $text)
                        .opacity(show ? 0 : 1)
                }
            
            Button {
            } label: {
                Image(systemName: show ? "eye.slash" : "eye")
            }
            ._onButtonGesture {
                pressing in self.show = pressing
            } perform: {}
        }
    }
}

struct SecureFieldWithShow_Previews: PreviewProvider {
    static var previews: some View {
        SecureFieldWithShow("prompt", text: .constant("text"), show: .constant(true))
    }
}
