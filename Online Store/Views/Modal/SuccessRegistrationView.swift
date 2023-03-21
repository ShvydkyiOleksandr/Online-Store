//
//  SuccessRegistrationView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import FirebaseAuth

struct SuccessRegistrationView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        VStack {
            Text("Registration Successful")
                .font(.title.bold())
            
            Rectangle()
                .frame(height: 2)
                .opacity(0.3)
            
            Image(systemName: "checkmark")
                .font(.system(size: 120).bold())
                .foregroundColor(.green)
            
            BlackButton(buttonName: "START") {
                authManager.authorize(modalManager: modalManager, alertManager: alertManager)
            }
        }
        .border(padding: 10)
        .padding(5)
    }
}

struct SuccessRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessRegistrationView()
            .background(Color("background"))
            .environmentObject(AuthManager())
            .environmentObject(AlertManager())
    }
}
