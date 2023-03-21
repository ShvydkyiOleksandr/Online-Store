//
//  ProfileViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 24.01.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI

@MainActor final class ProfileViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var street = ""
    @Published var apartment = ""
    @Published var building = ""
    @Published var phone = ""
    @Published var novaPoshtaNumber = ""
    @Published var selectedCity = User.Addresses.getCities().first!
    
    @Published var isEditing = false
    @Published var showProgressView = false
    
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var selectedPhotoData: Data?
    
    private lazy var usersRef = Firestore.firestore().collection("users")
    
    var isPhoneNumberValid: Bool { ValidationManager.isPhoneNumberValid(phoneNumber: phone) }
    var isStreetValid: Bool { ValidationManager.isStreetValid(street: street, apartment: apartment, building: building) }
    var isApartmentValid: Bool { ValidationManager.isApartmentValid(street: street, apartment: apartment, building: building) }
    var isBuildingValid: Bool { ValidationManager.isBuildingValid(street: street, apartment: apartment, building: building) }
    var isFirstNameValid: Bool { ValidationManager.isFirstNameValid(firstName: firstName) }
    var isLastNameValid: Bool { ValidationManager.isLastNameValid(lastName: lastName) }
    var isCityNameValid: Bool { ValidationManager.isCityNameValid(cityName: selectedCity) }
    var isNovaPoshtaNumberValid: Bool { ValidationManager.isNovaPoshtaNumberValid(number: novaPoshtaNumber) }
    
    func saveChanges(authManager: AuthManager, alertManager: AlertManager) {
        Task {
            guard isEditing else { isEditing.toggle(); return }
            guard let oldUser = authManager.currentUser else { return }
            showProgressView = true
            do {
                var changedUser = try validateUser(authManager: authManager)
                
                if let selectedPhotoData {
                    do {
                        let imageUrlString = try await StorageManager.uploadProfileImage(imageData: selectedPhotoData, userEmail: oldUser.email)
                        changedUser.imageUrlString = imageUrlString
                    } catch {
                        showProgressView = false
                        alertManager.show(error: error)
                    }
                }
                guard oldUser != changedUser else {
                    isEditing.toggle()
                    showProgressView = false
                    print("There is no changes")
                    return
                }
                do {
                    try await updateUserInfo(user: changedUser)
                    print("Profile changes are saved")
                    authManager.currentUser = changedUser
                    setupUserInfo(user: changedUser)
                    selectedPhotoData = nil
                    isEditing.toggle()
                    showProgressView = false
                    alertManager.show(title: "Changes are saved")
                } catch {
                    showProgressView = false
                    alertManager.show(error: error)
                }
            } catch {
                showProgressView = false
                alertManager.show(error: error)
            }
        }
    }
    
    func setSelectedPhoto() {
        Task {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotoData = data
            }
        }
    }
    
    private func validateUser(authManager: AuthManager) throws -> User {
        guard let oldUser = authManager.currentUser else { throw CustomError.userNotExist }
        
        let user = User(
            firstName: self.firstName,
            lastName: self.lastName,
            email: oldUser.email,
            phone: self.phone,
            addresses: User.Addresses(
                address: User.Addresses.Address(
                    street: self.street,
                    building: self.building,
                    apartment: self.apartment),
                cityName: self.selectedCity,
                novaPoshtaNumber: self.novaPoshtaNumber),
            imageUrlString: oldUser.imageUrlString)
        
        try ValidationManager.validateProfileForm(user: user)
        return user
    }
    
    private func updateUserInfo(user: User) async throws {
        do {
            try await usersRef.document(user.email).delete()
            do {
                try usersRef.document(user.email).setData(from: user)
            } catch {
                print("Error uploading user: \(error.localizedDescription)")
                throw CustomError.savingUser(error: error)
            }
        } catch {
            print("Error deleting old user data in Firebase: \(error.localizedDescription)")
            throw CustomError.savingUser(error: error)
        }
    }
    
    func setupUserInfo(user: User) {
        firstName = user.firstName
        lastName = user.lastName
        street = user.addresses?.address?.street ?? ""
        building = user.addresses?.address?.building ?? ""
        apartment = user.addresses?.address?.apartment ?? ""
        novaPoshtaNumber = user.addresses?.novaPoshtaNumber ?? ""
        if let cityName = user.addresses?.cityName { selectedCity = cityName }
        phone = user.phone ?? ""
    }
}
