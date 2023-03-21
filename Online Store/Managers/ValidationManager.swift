//
//  ValidationManager.swift
//  Online Store
//
//  Created by Олександр Швидкий on 24.01.2023.
//

import Foundation

final class ValidationManager {
    static func isFirstNameValid(firstName: String) -> Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    static func isLastNameValid(lastName: String) -> Bool {
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    static func isUserEmailValid(email: String) -> Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: email)
    }
    
    static func isPasswordValid(password: String) -> Bool {
        password.count >= 6
    }
    
    static func passwordMatch(password: String, repeatedPassword: String) -> Bool {
        guard !password.isEmpty, !repeatedPassword.isEmpty else { return false }
        return password == repeatedPassword
    }
    
    static func isPhoneNumberValid(phoneNumber: String) -> Bool {
        let trimmedPhoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
        return trimmedPhoneNumber.isEmpty ? true : trimmedPhoneNumber.count >= 10
    }
    
    private static func isAddressEmpty(street: String, apartment: String, building: String) -> Bool {
        street.isEmpty && apartment.isEmpty && building.isEmpty
    }
    
    static func isStreetValid(street: String, apartment: String, building: String) -> Bool {
        isAddressEmpty(street: street, apartment: apartment, building: building) ? true : !street.isEmpty
    }
    
    static func isApartmentValid(street: String, apartment: String, building: String) -> Bool {
        isAddressEmpty(street: street, apartment: apartment, building: building) ? true : !apartment.isEmpty
    }
    
    static func isBuildingValid(street: String, apartment: String, building: String) -> Bool {
        isAddressEmpty(street: street, apartment: apartment, building: building) ? true : !building.isEmpty
    }
    
    static func isCityNameValid(cityName: String) -> Bool {
        cityName != "None"
    }
    
    static func isNovaPoshtaNumberValid(number: String) -> Bool {
        !number.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private static func isOrderProductsEmpty(productsDict: [String: Int]) -> Bool {
        productsDict.isEmpty
    }
    
    private static func validateAddress(address: User.Addresses.Address?) throws {
        guard let address else { throw CustomError.addressIsEmpty }
        guard !address.street.isEmpty else { throw CustomError.streetIsEmpty }
        guard !address.apartment.isEmpty else { throw CustomError.apartmentIsEmpty }
        guard !address.building.isEmpty else { throw CustomError.buildingIsEmpty }
    }
    
    private static func validateFullName(firstName: String, lastName: String) throws {
        guard isFirstNameValid(firstName: firstName) else { throw CustomError.firstNameIsEmpty }
        guard isLastNameValid(lastName: lastName) else { throw CustomError.lastNameIsEmpty }
    }
    
    static func validateSignUpForm(isAgree: Bool, user: User, password: String, repeatedPassword: String) throws {
        guard isAgree else { throw CustomError.agreementNotAccepted }
        try validateFullName(firstName: user.firstName, lastName: user.lastName)
        guard isUserEmailValid(email: user.email) else { throw CustomError.emailFormaIsWrong }
        
        if let phoneNumber = user.phone {
            guard isPhoneNumberValid(phoneNumber: phoneNumber) else { throw CustomError.shortPhone }
        }
        
        if let address = user.addresses?.address {
            try validateAddress(address: address)
        }
        
        guard isPasswordValid(password: password) else { throw CustomError.shortPassword }
        guard passwordMatch(password: password, repeatedPassword: repeatedPassword) else { throw CustomError.passwordNotMatch }
    }
    
    static func validateProfileForm(user: User) throws {
        try validateFullName(firstName: user.firstName, lastName: user.lastName)
        
        if let userPhone = user.phone {
            guard isPhoneNumberValid(phoneNumber: userPhone) else { throw CustomError.shortPhone }
        }
        
        if let address = user.addresses?.address { try validateAddress(address: address) }
    }
    
    static func validateOrder(order: Order) throws {
        guard !isOrderProductsEmpty(productsDict: order.products) else { throw CustomError.productsIsEmpty }
        let receiver = order.receiver
        try validateFullName(firstName: receiver.firstName, lastName: receiver.lastName)
        guard isPhoneNumberValid(phoneNumber: order.receiver.phone) else { throw CustomError.shortPhone }
        guard isUserEmailValid(email: order.receiver.email) else { throw CustomError.emailFormaIsWrong }
        guard isCityNameValid(cityName: order.cityName) else { throw CustomError.cityNameNotSelected }
        
        if order.deliveryType == .novaPoshta {
            guard let novaPoshtaNumber = order.novaPoshtaNumber, isNovaPoshtaNumberValid(number: novaPoshtaNumber) else {
                throw CustomError.novaPoshtaNumberIsEmpty
            }
        } else {
            try validateAddress(address: order.address)
        }
    }
    
    static func validateLoginForm(email: String, password: String) throws {
        guard isUserEmailValid(email: email) else { throw CustomError.emailFormaIsWrong }
        guard isPasswordValid(password: password) else { throw CustomError.passwordIsEmpty }
    }
}
