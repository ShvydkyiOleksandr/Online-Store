//
//  Product.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct Product: Identifiable, Codable, Hashable, Comparable  {
    let id: String
    let name: String
    let description: String
    var formattedDescription: LocalizedStringKey { LocalizedStringKey(description) }
    let composition: [String]
    let volume: Int
    let allVolumes: [Int: String]
    let article: String
    let price: Double
    let typeString: String
    var type: ProductType { ProductType(rawValue: typeString) ?? .none}
    var imageUrlString: String?
    var imageUrl: URL? { URL(string: imageUrlString ?? "") }
    let brand: String
    
    static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.name < rhs.name
    }
    
    enum ProductType: String, Codable, CaseIterable, Identifiable {
        case homeCare = "Home care"
        case professionalUse = "Professional use"
        
        case none = "None"
        
        case revival = "Revival"
        case divine = "Divine"
        case bondAngel = "Bond Angel"
        case gorgeousVolume = "Gorgeous Volume"
        
        var id: Self { self }
    }
}
