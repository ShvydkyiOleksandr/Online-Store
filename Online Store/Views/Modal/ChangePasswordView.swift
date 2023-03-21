//
//  ChangePasswordView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 13.01.2023.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var alertManager: AlertManager
    @FocusState private var isFocused
    @State var showPassword = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LogoView().frame(height: 150)
                
                VStack {
                    Text("CHANGE PASSWORD").font(.title.bold())
                    
                    SecureFieldWithShow("New password", text: $authManager.password, show: $showPassword)
                        .innerShadowStyle(isCorrect: authManager.isPasswordValid)
                        .textContentType(.newPassword)
                        .textInputAutocapitalization(.never)
                        .focused($isFocused)
                        .onSubmit { isFocused = false }
                        .disableAutocorrection(true)
                    
                    BlackButton(buttonName: "CHANGE") {
                        authManager.changePassword(modalManager: modalManager, alertManager: alertManager)
                    }
                    .disabled(!authManager.isPasswordValid)
                    .padding(.top, 5)
                }
                .border(padding: 10)
                .padding(5)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { modalManager.activeModal = .tabBarView }
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
            .background(Color("background"))
            .environmentObject(AuthManager())
            .environmentObject(ModalManager())
            .environmentObject(AlertManager())
    }
}
