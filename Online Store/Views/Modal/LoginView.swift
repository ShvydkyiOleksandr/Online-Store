//
//  LoginView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var alertManager: AlertManager
    @FocusState private var focusedField: FocusedField?
    @State private var showPassword = false
    
    var body: some View {
        VStack(spacing: 20) {
            LogoView().frame(height: 150)
            
            VStack {
                Text("LOGIN").font(.title.bold())
                
                Group {
                    TextField("Login", text: $authManager.email)
                        .innerShadowStyle(isCorrect: authManager.isUserEmailValid)
                        .textContentType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                    
                    SecureFieldWithShow("Password", text: $authManager.password, show: $showPassword)
                        .innerShadowStyle(isCorrect: authManager.isPasswordValid)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                
                BlackButton(buttonName: "Login") {
                    authManager.authorize(modalManager: modalManager, alertManager: alertManager)
                }
                .padding(.top, 5)
                
                HStack(spacing: 0) {
                    BlackButton(buttonName: "Register") { modalManager.activeModal = .registrationView }
                    WhiteButton(buttonName: "Forgot password") { modalManager.activeModal = .forgotView}
                }
            }
            .border(padding: 10)
            .padding(5)
            
            Spacer()
        }
        .onSubmit { focusedField = focusedField == .email ? .password : nil }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .background(Color("background"))
            .environmentObject(AuthManager())
            .environmentObject(ModalManager())
            .environmentObject(AlertManager())
    }
}
