//
//  ProceduresViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 18.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor final class ProceduresViewModel: ObservableObject {
    @Published private(set) var procedures = [Procedure]()
    @Published var searchText = ""
    private let db = Firestore.firestore()
    var proceduresRef: CollectionReference { db.collection("procedures") }
    var brand: Brand?
    
    var filteredProcedures: [Procedure] {
        if searchText.isEmpty {
            return procedures.filter { $0.brand == brand?.name }
        } else {
            return procedures.filter { $0.brand == brand?.name }.filter { $0.name.lowercased().contains(searchText.lowercased())}
        }
    }
    
    init() {
        getAllProcedures()
    }
    
    private func getAllProcedures() {
        Task {
            do {
                let documents = try await proceduresRef.getDocuments().documents
                
                procedures = documents.compactMap {
                    do {
                        return try $0.data(as: Procedure.self)
                    } catch {
                        print("Error decoding document into Procedure: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                print("Procedures loaded")
            } catch {
                print("Error fetching procedures: \(error.localizedDescription)")
            }
        }
    }
}
