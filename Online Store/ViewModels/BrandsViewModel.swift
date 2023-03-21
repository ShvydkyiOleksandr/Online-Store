//
//  BrandsViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 17.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor final class BrandsViewModel: ObservableObject {
    @Published private(set) var brands = [Brand]()
    @Published var searchText = ""
    private let db = Firestore.firestore()
    var brandsRef: CollectionReference { db.collection("brands") }

    var filteredBrands: [Brand] {
        searchText.isEmpty ? brands : brands.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    init() {
        getBrands()
    }
    
    private func getBrands() {
        Task {
            do {
                let documents = try await brandsRef.getDocuments().documents
                
                brands = documents.compactMap {
                    do {
                        return try $0.data(as: Brand.self)
                    } catch {
                        print("Error decoding document into Brand: \(error)")
                        return nil
                    }
                }
                
                self.brands.sort()
                print("Brands loaded")
                
            } catch {
                print("Error fetching brands: \(error.localizedDescription)")
            }
        }
    }
}
