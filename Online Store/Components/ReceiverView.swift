//
//  ReceiverView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

struct ReceiverView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var basketVM: BasketViewModel
    @FocusState var focusedField: FocusedField?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Receiver info:")
                .font(.title3.bold())
            
            HStack {
                TextField("First name", text: $basketVM.firstName)
                    .foregroundColor(.accentColor)
                    .innerShadowStyle(isCorrect: basketVM.isFirstNameValid)
                    .textContentType(.name)
                    .focused($focusedField, equals: .firstName)
                    .disableAutocorrection(true)
                
                TextField("Last name", text: $basketVM.lastName)
                    .foregroundColor(.accentColor)
                    .innerShadowStyle(isCorrect: basketVM.isLastNameValid)
                    .textContentType(.name)
                    .focused($focusedField, equals: .lastName)
                    .disableAutocorrection(true)
            }
            
            TextField("Email", text: $basketVM.email)
                .foregroundColor(.accentColor)
                .innerShadowStyle(isCorrect: basketVM.isEmailValid)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .focused($focusedField, equals: .email)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            
            TextField("Phone number", text: $basketVM.phoneNumber)
                .foregroundColor(.accentColor)
                .innerShadowStyle(isCorrect: basketVM.phoneNumber.count > 9)
                .textContentType(.telephoneNumber)
                .focused($focusedField, equals: .phoneNumber)
                .disableAutocorrection(true)
                .keyboardType(.phonePad)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .border(radius: 20, padding: 10)
    }
}

struct ReceiverView_Previews: PreviewProvider {
    static var authManager: AuthManager {
        let manager = AuthManager()
        manager.currentUser = previewUser
        return manager
    }
    static var previews: some View {
        ReceiverView()
            .environmentObject(authManager)
            .environmentObject(BasketViewModel(isInPreview: true))
    }
}
