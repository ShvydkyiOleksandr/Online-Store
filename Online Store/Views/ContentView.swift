//
//  ContentView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        Group {
            switch modalManager.activeModal {
            case .splashView: SplashView()
            case .forgotView: ForgotView()
            case .loginView: LoginView()
            case .registrationView: RegistrationView()
            case .tabBarView: TabViews()
            case .successRegistrationView: SuccessRegistrationView()
            case .changePasswordView: ChangePasswordView()
            }
        }
        .alert(alertManager.title, isPresented: $alertManager.showAlert) {
        } message: { Text(alertManager.message) }
        .background(Color("background"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModalManager())
            .environmentObject(AuthManager())
            .environmentObject(NetworkReachability())
            .environmentObject(AlertManager())
    }
}
