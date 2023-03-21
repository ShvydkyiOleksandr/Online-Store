//
//  ForgotView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct ForgotView: View {
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var alertManager: AlertManager
    @FocusState private var isFocused
    
    var body: some View {
        NavigationView {
            VStack {
                Text("RESTORE PASSWORD")
                    .font(.title.bold())
                
                TextField("Login", text: $authManager.email)
                    .innerShadowStyle(isCorrect: authManager.isUserEmailValid)
                    .textContentType(.emailAddress)
                    .focused($isFocused)
                    .onSubmit { isFocused = false }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                
                BlackButton(buttonName: "RESTORE") { authManager.restore(modalManager: modalManager, alertManager: alertManager) }
                    .frame(width: 150, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
            }
            .border(padding: 10)
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { modalManager.activeModal = .loginView }
                }
            }
        }
    }
}

struct ForgotView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotView()
            .background(Color("background"))
            .environmentObject(ModalManager())
            .environmentObject(AuthManager())
            .environmentObject(AlertManager())
    }
}
