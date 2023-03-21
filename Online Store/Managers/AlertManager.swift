//
//  AlertManager.swift
//  Online Store
//
//  Created by Олександр Швидкий on 09.03.2023.
//

import Foundation
 
@MainActor final class AlertManager: ObservableObject {
    @Published var showAlert = false
    private(set) var title = ""
    private(set) var message = ""
    
    func show(error: Error) {
        let customError = error as? DescribedError
        title = "Error"
        message = customError?.description ?? error.localizedDescription
        showAlert = true
        print(message)
    }
    
    func show(title: String, message: String? = nil) {
        self.title = title
        self.message = message ?? ""
        showAlert = true
    }
    
    func showSuccesfulOrder() {
        title = "Your order successfully has been placed"
        message = "Wait for a call from the manager about the details of the order"
        showAlert = true
    }
    
    func showPasswordIsChanged() {
        title = "Successful"
        message = "Password is changed"
        showAlert = true
    }
    
    func showRessetPassword() {
        title = "Password reset email sent"
        message = "Check your inbox for an email to reset your password"
        showAlert = true
    }
}
