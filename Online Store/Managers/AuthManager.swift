//
//  AuthManager.swift
//  Online Store
//
//  Created by Олександр Швидкий on 13.01.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor final class AuthManager: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var isAgree = false
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phone = ""
    @Published var selectedCity = User.Addresses.getCities().first!
    @Published var novaPoshtaNumber = ""
    @Published var street = ""
    @Published var apartment = ""
    @Published var building = ""
    @Published var currentUser: User!
    
    private lazy var usersRef = Firestore.firestore().collection("users")
    
    var isUserEmailValid: Bool { ValidationManager.isUserEmailValid(email: email) }
    var passwordMatch: Bool { ValidationManager.passwordMatch(password: password, repeatedPassword: repeatedPassword) }
    var isPhoneNumberValid: Bool { ValidationManager.isPhoneNumberValid(phoneNumber: phone) }
    var isStreetValid: Bool { ValidationManager.isStreetValid(street: street, apartment: apartment, building: building) }
    var isApartmentValid: Bool { ValidationManager.isApartmentValid(street: street, apartment: apartment, building: building) }
    var isBuildingValid: Bool { ValidationManager.isBuildingValid(street: street, apartment: apartment, building: building) }
    var isPasswordValid: Bool { ValidationManager.isPasswordValid(password: password) }
    var isFirstNameValid: Bool { ValidationManager.isFirstNameValid(firstName: firstName) }
    var isLastNameValid: Bool { ValidationManager.isLastNameValid(lastName: lastName) }
    var isCityNameValid: Bool { ValidationManager.isCityNameValid(cityName: selectedCity) }
    var isNovaPoshtaNumberValid: Bool { ValidationManager.isNovaPoshtaNumberValid(number: novaPoshtaNumber) }
    
    func register(modalManager: ModalManager, alertManager: AlertManager) {
        Task {
            do {
                let user = try validateUser()
                do {
                    try await registerWithEmail(user: user)
                    modalManager.activeModal = .successRegistrationView
                } catch {
                    alertManager.show(error: error)
                }
            } catch {
                alertManager.show(error: error)
            }
        }
    }
    
    func authorize(modalManager: ModalManager, alertManager: AlertManager) {
        Task {
            do {
                try await login()
                do {
                    try await getUser()
                    modalManager.activeModal = .tabBarView
                } catch {
                    alertManager.show(error: error)
                }
            } catch {
                alertManager.show(error: error)
            }
        }
    }
    
    func restore(modalManager: ModalManager, alertManager: AlertManager) {
        Task {
            do {
                try await sendPasswordResetEmail()
                modalManager.activeModal = .loginView
            } catch {
                alertManager.show(error: error)
            }
        }
    }
    
    func signOut(modalManager: ModalManager, alertManager: AlertManager) {
        Task {
            do {
                try Auth.auth().signOut()
                modalManager.activeModal = .loginView
            } catch {
                alertManager.show(error: error)
            }
        }
    }
    
    func hideSplashView(modalManager: ModalManager, alertManager: AlertManager) {
        Task {
            do {
                try await getUser()
                modalManager.activeModal = .tabBarView
            } catch let error as CustomError {
                modalManager.activeModal = .loginView
                if error != CustomError.userNotExist { alertManager.show(error: error) }
            }
        }
    }
    
    func changePassword(modalManager: ModalManager, alertManager: AlertManager) {
        Task {
            do {
                try await Auth.auth().currentUser?.updatePassword(to: password)
                modalManager.activeModal = .tabBarView
                self.password = ""
                alertManager.showPasswordIsChanged()
            } catch {
                alertManager.show(error: CustomError.changePassword(error: error))
            }
        }
    }
    
    private func validateUser() throws -> User {
        let user = User(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            addresses: User.Addresses(
                address: User.Addresses.Address(
                    street: street,
                    building: building,
                    apartment: apartment),
                cityName: selectedCity,
                novaPoshtaNumber: novaPoshtaNumber))
        
        try ValidationManager.validateSignUpForm(
            isAgree: isAgree,
            user: user,
            password: password,
            repeatedPassword: repeatedPassword)
        
        return user
    }
    
    private func registerWithEmail(user: User) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("Register")
            try uploadUser(user: user)
        } catch {
            throw CustomError.authorization(error: error)
        }
    }
    
    private func login() async throws {
        try ValidationManager.validateLoginForm(email: email, password: password)
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            password = ""
            print("Success login")
        } catch {
            throw CustomError.authorization(error: error)
        }
    }
    
    private func sendPasswordResetEmail() async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            self.email = ""
            print("Password reset email sent")
        } catch {
            throw CustomError.resetingPassword(error: error)
        }
    }
    
    private func uploadUser(user: User) throws {
        do {
            try usersRef.document(user.email).setData(from: user)
            
            self.firstName = ""
            self.lastName = ""
            self.phone = ""
            self.street = ""
            self.apartment = ""
            self.building = ""
            self.novaPoshtaNumber = ""
            self.selectedCity = User.Addresses.getCities().first ?? ""
            self.repeatedPassword = ""
            
            print("User is successfully written!")
        } catch {
            print("Error uploading user: \(error.localizedDescription)")
            throw CustomError.registration(error: error)
        }
    }
    
    func getUser() async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else { throw CustomError.userNotExist }
        
        do {
            let document = try await usersRef.document(email).getDocument()
            
            if document.exists {
                do {
                    currentUser = try document.data(as: User.self)
                    self.email = ""
                    print("User received")
                } catch {
                    print("Error decoding document into User: \(error.localizedDescription)")
                    throw CustomError.authorization(error: error)
                }
            } else {
                throw CustomError.authorization()
            }
        } catch {
            print("Error getting user: \(error.localizedDescription)")
            throw CustomError.authorization(error: error)
        }
    }
}
