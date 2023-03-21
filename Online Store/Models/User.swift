//
//  User.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import Foundation

struct User: Codable, Equatable {
    let firstName: String
    let lastName: String
    let email: String
    var phone: String?
    var addresses: Addresses?
    var imageUrlString: String?
    var imageUrl: URL? { URL(string: imageUrlString ?? "") }
    var fullName: String { "\(firstName) \(lastName)" }
    
    init(firstName: String, lastName: String, email: String, phone: String? = nil, addresses: Addresses? = nil, imageUrlString: String? = nil) {
        self.firstName = firstName.trimmingCharacters(in: .whitespaces)
        self.lastName = lastName.trimmingCharacters(in: .whitespaces)
        self.email = email
        
        if let trimmedPhone = phone?.trimmingCharacters(in: .whitespaces), !trimmedPhone.isEmpty {
            self.phone = trimmedPhone
        }
        
        self.addresses = addresses
        self.imageUrlString = imageUrlString
    }
    
    struct Addresses: Codable, Equatable {
        var address: Address?
        var cityName: String?
        var novaPoshtaNumber: String?
        
        var addressString: String? {
            guard let address else { return nil }
            return "\(address.street) Street, Bldg. \(address.apartment), Apt. \(address.apartment)"
        }
        
        init?(address: Address? = nil, cityName: String? = nil, novaPoshtaNumber: String? = nil) {
            guard !(address == nil && cityName == nil && novaPoshtaNumber == nil) else { return nil }
            
            self.address = address
            
            if let trimmedCityName = cityName?.trimmingCharacters(in: .whitespaces), !trimmedCityName.isEmpty {
                self.cityName = trimmedCityName
            }
            
            if let trimmedNovaPoshtaNumber = novaPoshtaNumber?.trimmingCharacters(in: .whitespaces), !trimmedNovaPoshtaNumber.isEmpty {
                self.novaPoshtaNumber = trimmedNovaPoshtaNumber
            }
        }
        
        static func getCities() -> [String] {
            guard let citiesURL = Bundle.main.url(forResource: "cities", withExtension: "txt") else {
                fatalError("Could not find cities.txt in the app bundle.")
            }
            guard let citiesString = try? String(contentsOf: citiesURL) else {
                fatalError("Could not load cities.txt from the app bundle.")
            }
            
            var cities = citiesString.components(separatedBy: "\n").sorted()
            cities[0] = "None"
            return cities
        }
        
        struct Address: Codable, Equatable {
            let street: String
            let building: String
            let apartment: String
            
            init?(street: String, building: String, apartment: String) {
                guard !(street.isEmpty && building.isEmpty && apartment.isEmpty) else { return nil }
                
                self.street = street
                self.building = building
                self.apartment = apartment
            }
        }
    }
}
