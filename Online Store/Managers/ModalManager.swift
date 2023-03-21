//
//  ViewsManager.swift
//  Online Store
//
//  Created by Олександр Швидкий on 13.01.2023.
//

import Foundation

@MainActor final class ModalManager: ObservableObject {
    enum ActiveModals {
        case splashView
        case loginView
        case registrationView
        case successRegistrationView
        case forgotView
        case tabBarView
        case changePasswordView
    }
    
    @Published public var activeModal: ActiveModals = .splashView
}
