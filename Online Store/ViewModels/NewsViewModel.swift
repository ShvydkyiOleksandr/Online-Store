//
//  NewsViewModel.swift
//  Online Store
//
//  Created by Олександр Швидкий on 15.01.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor final class NewsViewModel: ObservableObject {
    @Published private(set) var news = [News]()
    @Published private(set) var viewedNews = [String]()
    
    let isInPreview: Bool
    
    private let db = Firestore.firestore()
    var newsRef: CollectionReference { db.collection("news") }
    private var userEmail: String { isInPreview ? previewUser.email : Auth.auth().currentUser!.email! }
    private var userRef: DocumentReference { db.collection("users").document(userEmail) }
    private var viewedNewsRef: CollectionReference { userRef.collection("viewedNews") }
    
    var badge: Int? {
        let count = news.count - viewedNews.count
        return count == 0 ? nil : count
    }
    
    init(isInPreview: Bool = false) {
        self.isInPreview = isInPreview
        
        getViewedNews()
        getNews()
    }
    
    private func getNews() {
        newsRef.addSnapshotListener { querySnapshot, error in
            if let error {
                print("Error fetching news: \(error.localizedDescription)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                self.news = documents.compactMap {
                    do {
                        return try $0.data(as: News.self)
                    } catch {
                        print("Error decoding document into News: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                self.news.sort { $0.date < $1.date }
                print("News loaded")
            }
        }
    }
    
    private func getViewedNews() {
        Task {
            do {
                let documents = try await viewedNewsRef.getDocuments().documents
                let viewedNews = documents.map { $0.documentID }
                print("viewedNewsList loaded")
                self.viewedNews = viewedNews
            } catch {
                print("Error fetching viewedNewsList error: \(error.localizedDescription)")
            }
        }
    }
    
    func addToViewedNews(news: News) {
        Task {
            let id = news.id
            do {
                try await viewedNewsRef.document(id).setData([:])
                viewedNews.append(id)
                print("News added to viewed news")
            } catch {
                print("Error adding news to viewed news: \(error.localizedDescription)")
            }
        }
    }
    
    func isViewed(news: News) -> Bool {
        viewedNews.contains(news.id)
    }
}
