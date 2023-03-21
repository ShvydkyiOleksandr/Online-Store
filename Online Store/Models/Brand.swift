//
//  Brand.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import Foundation

struct Brand: Codable, Equatable, Comparable, Identifiable {
    let name: String
    var id = UUID().uuidString
    var imageUrlString: String?
    var imageUrl: URL? { URL(string: imageUrlString ?? "") }
    
    static func ==(lhs: Brand, rhs: Brand) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Brand, rhs: Brand) -> Bool {
        lhs.name < rhs.name
    }
}
