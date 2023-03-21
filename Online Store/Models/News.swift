//
//  News.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

struct News: Identifiable, Codable {
    var id = UUID().uuidString
    var previewImageUrlString: String?
    var previewImageUrl: URL? { URL(string: previewImageUrlString ?? "") }
    var imageUrlString: String?
    var imageUrl: URL? { URL(string: imageUrlString ?? "") }
    let name: String
    let shortDescription: String
    let description: String
    var date = Date()
    var formattedDate: String { date.formatted(.dateTime.hour().minute().day().month().year()) }
    var formattedDescription: LocalizedStringKey { LocalizedStringKey(description) }
}
