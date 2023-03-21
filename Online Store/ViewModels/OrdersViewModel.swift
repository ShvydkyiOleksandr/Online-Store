//
//  OrdersViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 24.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor final class OrdersViewModel: ObservableObject {
    @Published private(set) var userOrders = [Order]()
    
    private lazy var db = Firestore.firestore()
    private lazy var ordersRef = db.collection("orders")
    private lazy var userEmail = isInPreview ? previewUser.email : Auth.auth().currentUser!.email!
    private lazy var userRef = db.collection("users").document(userEmail)
    private lazy var userOrdersRef = userRef.collection("orders")
    
    let isInPreview: Bool
    
    var completedOrders: [Order] {
        userOrders.filter { $0.status == .received }
    }
    
    var processingOrders: [Order] {
        userOrders.filter { $0.status != .received }
    }
    
    init(isInPreview: Bool = false) {
        self.isInPreview = isInPreview
    }
    
    func getUserOrders() {
        Task {
            do {
                let documents = try await userOrdersRef.getDocuments().documents
                
                do {
                    userOrders = try await withThrowingTaskGroup(of: [Order].self) { group in
                        for document in documents {
                            group.addTask { return try await [self.getOrder(with: document.documentID)] }
                        }
                        
                        let allUserOrders = try await group.reduce(into: [Order]()) { $0 += $1 }
                        return allUserOrders.sorted { $0.date > $1.date }
                    }
                    
                    print("User orders fetched")
                } catch let error as DescribedError {
                    print("Failed to load user orders: \(error.description)")
                } catch {
                    print("Failed to load user's orders: \(error.localizedDescription)")
                }
            } catch {
                print("Error fetching userOderList, error: \(error.localizedDescription)")
            }
        }
    }
    
    private func getOrder(with id: String) async throws -> Order {
        let docRef = ordersRef.document(id)
        let document = try await docRef.getDocument()
        if document.exists {
            return try document.data(as: Order.self)
        } else {
            print("Document does not exist")
            throw CustomError.gettingOrder
        }
    }
}
