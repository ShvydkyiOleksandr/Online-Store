//
//  Procedure.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

struct Procedure: Identifiable, Codable, Equatable {
    var imageUrlString: String?
    let name: String
    let shortDescription: String
    let description: String
    let brand: String
    var id = UUID().uuidString
    var imageUrl: URL? { URL(string: imageUrlString ?? "") }
    var video: String?
    var formattedDescription: LocalizedStringKey { LocalizedStringKey(description) }
}
