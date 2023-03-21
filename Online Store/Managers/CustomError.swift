//
//  ValidationError.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.02.2023.
//

import Foundation

protocol DescribedError: Error {
    var description: String { get }
}

enum CustomError: DescribedError, Equatable {
    case productsIsEmpty
    case addressIsEmpty
    case apartmentIsEmpty
    case buildingIsEmpty
    case streetIsEmpty
    case firstNameIsEmpty
    case lastNameIsEmpty
    case agreementNotAccepted
    case emailFormaIsWrong
    case shortPhone
    case shortPassword
    case passwordNotMatch
    case cityNameNotSelected
    case novaPoshtaNumberIsEmpty
    case passwordIsEmpty
    
    case paymentError
    
    case authorization(error: Error? = nil)
    case registration(error: Error)
    case resetingPassword(error: Error)
    case changePassword(error: Error)
    case logout(error: Error)
    
    case userNotExist
    case savingUser(error: Error? = nil)
    
    case savingImageError
    
    case deletingFromLikedProducts(error: Error)
    case addingToLikedProducts(error: Error)
    case savingBasketProducts(error: Error)
    case deletingProductsFromBasket(error: Error)
    
    case addingOrder(error: Error)
    case gettingOrders(error: Error)
    case gettingOrder
    
    var description: String {
        switch self {
        case .addressIsEmpty:
            return "Address fields is empty. You need to enter the address text fields!"
        case .apartmentIsEmpty:
            return "Apartment field is empty. You need to enter the apartment text field!"
        case .buildingIsEmpty:
            return "Building field is empty. You need to enter the building text field!"
        case .streetIsEmpty:
            return "Street field is empty. You need to enter the street text field!"
        case .firstNameIsEmpty:
            return "First name field is empty. You need to enter the first name text field!"
        case .lastNameIsEmpty:
            return "Last name field is empty. You need to enter the last name text field!"
        case .agreementNotAccepted:
            return "You need to accept Agreement to register!"
        case .emailFormaIsWrong:
            return "Email format is wrong!"
        case .shortPhone:
            return "Phone number must be at latest 10 characters!"
        case .shortPassword:
            return "Password must be at latest 6 character!"
        case .passwordNotMatch:
            return "Password are not the same!"
        case .cityNameNotSelected:
            return "City is not selected!"
        case .novaPoshtaNumberIsEmpty:
            return "Nova Poshta number text field is empty. You need to enter the Nova Poshta number text field!"
        case .productsIsEmpty:
            return "Basket is empty. You can not make order without products!"
        case .passwordIsEmpty:
            return "Password is empty. Enter the password!"
            
        case .paymentError:
            return "An error occurred during payment!"
            
        case .registration(error: let error):
            return "An error occurred during registration: \(error.localizedDescription)!"
        case .resetingPassword(error: let error):
            return "An error occurred during reseting error: \(error.localizedDescription)!"
        case .authorization(error: let error):
            return "An error occurred during authorization\(error != nil ? ": \(error!.localizedDescription)!" : "!")"
        case .changePassword(error: let error):
            return "An error occurred during changing password: \(error.localizedDescription)!"
        case .logout(error: let error):
            return "An error occurred during logout: \(error.localizedDescription)!"
            
        case .userNotExist:
            return "User not exist!"
        case .savingUser(error: let error):
            return "An error occurred during saving user\(error != nil ? ": \(error!.localizedDescription)!" : "!")"
            
        case .savingImageError:
            return "An error occurred during saving image!"
            
        case .deletingFromLikedProducts(error: let error):
            return "An error occurred during deleting product from liked products: \(error.localizedDescription)!"
        case .addingToLikedProducts(error: let error):
            return "An error occurred during adding product to liked products: \(error.localizedDescription)!"
        case .savingBasketProducts(error: let error):
            return "An error occurred during saving products in basket: \(error.localizedDescription)!"
        case .deletingProductsFromBasket(error: let error):
            return "An error occurred during deleting product from basket: \(error.localizedDescription)!"
        case .addingOrder(error: let error):
            return "An error occurred during adding order: \(error.localizedDescription)!"
        case .gettingOrders(error: let error):
            return "An error occurred during getting orders: \(error.localizedDescription)!"
        case .gettingOrder:
            return "An error occurred during getting order!"
        }
    }
    
    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
        lhs.description == rhs.description
    }
}
