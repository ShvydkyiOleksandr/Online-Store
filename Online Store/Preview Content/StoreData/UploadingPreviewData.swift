//
//  UploadingPreviewData.swift
//  Online Store
//
//  Created by Олександр Швидкий on 15.03.2023.
//

import UIKit.UIImage
import FirebaseStorage
import FirebaseFirestore

extension NewsViewModel {
    func uploadNews() {
        newsData.forEach {
            do {
                try newsRef.document().setData(from: $0)
            } catch {
                print("Error uploading news to Firestore: \(error.localizedDescription)")
            }
        }
        
        print("News uploaded")
    }
}

extension BrandsViewModel {
    func uploadBrands() {
        brandsData.forEach {
            do {
                try brandsRef.document().setData(from: $0)
            } catch {
                print("Error adding brand to Firestore: \(error.localizedDescription)")
            }
        }
        
        print("Brands uploaded")
    }
}

extension ProductsViewModel {
    func uploadProducts() {
        productsData.forEach {
            do {
                try productsRef.document().setData(from: $0)
            } catch {
                print("Error adding product to Firestore: \(error.localizedDescription)")
            }
        }
        
        print("Products uploaded")
    }
    
    func uploadAvailabilityList() async {
        let dict = Dictionary(uniqueKeysWithValues: products.map { ($0.id, Int.random(in: 0...10)) })
        
        do {
            try await availabilityListRef.setData(dict)
            print("AvailabilityList uploaded")
        } catch {
            print("Error during uploading AvailabilityList: \(error.localizedDescription)")
        }
    }
}

extension ProceduresViewModel {
    func uploadProcedures() {
        proceduresData.forEach {
            do {
                try proceduresRef.document().setData(from: $0)
            } catch {
                print("Error adding procedures to Firestore: \(error.localizedDescription)")
            }
        }
        
        print("Procedures uploaded")
    }
}

extension StorageManager {
    static func uploadImagesToStorage() async throws {
        let brandsRef = storageRef.child("brands")
        let productsRef = storageRef.child("products")
        let proceduresRef = storageRef.child("procedures")
        let newsRef = storageRef.child("news")

        async let newsImageUrlStrings = StorageManager.uploadImageSet(ref: newsRef, items: newsData, prefix: "news")
        async let previewNewsImageUrlStrings = StorageManager.uploadImageSet(ref: newsRef, items: newsData, prefix: "previewNews")
        async let brandImageUrlStrings = StorageManager.uploadImageSet(ref: brandsRef, items: brandsData, prefix: "brand")
        async let productImageUrlStrings =  StorageManager.uploadImageSet(ref: productsRef, items: productsData, prefix: "product", ids: productIds)
        async let procedureImageUrlStrings = StorageManager.uploadImageSet(ref: proceduresRef, items: proceduresData, prefix: "procedure")

        for index in newsData.indices {
            newsData[index].imageUrlString = try await newsImageUrlStrings[index]
            newsData[index].previewImageUrlString = try await previewNewsImageUrlStrings[index]
        }

        for index in brandsData.indices { brandsData[index].imageUrlString = try await brandImageUrlStrings[index] }
        for index in productsData.indices { productsData[index].imageUrlString = try await productImageUrlStrings[index] }
        for index in proceduresData.indices { proceduresData[index].imageUrlString = try await procedureImageUrlStrings[index] }
        print("Preview images uploaded to Storage")
    }
    
    private static func uploadImageSet<T: Identifiable>(
        ref: StorageReference,
        items: Array<T>,
        prefix: String,
        ids: [String]? = nil) async throws -> [Int: String] {
            return try await withThrowingTaskGroup(of: [Int: String].self) { group in
                for (index, item) in items.enumerated() {
                    let imageName = "\(prefix)\(index)"
                    guard let image = UIImage(named: imageName), let imageData = image.pngData() else { fatalError() }
                    guard let name = ids == nil ? item.id as? String : ids?[index] else { fatalError() }
                    let id = prefix == "news" || prefix == "previewNews" ? imageName : name
                    group.addTask { [index: try await StorageManager.uploadImage(imageData: imageData, ref: ref, id: id)] }
                }
                
                let urlsDict = try await group.reduce(into: [Int: String]()) { $0.merge($1) { (first, _) in first } }
                print("\(prefix)UrlsDict fetched")
                return urlsDict
            }
        }
}

func uploadPreviewUserData() async throws {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(previewUser.email)
    try userRef.setData(from: previewUser)
    try db.collection("orders").document(previewOrder.id).setData(from: previewOrder)
    try await userRef.collection("likedProductsCollection").document(previewProduct.id).setData([:])
    try await userRef.collection("products").document("productsDict").setData([previewProduct.id : 2])
    try await userRef.collection("orders").document(previewOrder.id).setData([:])
    print("PreviewUserData uploaded")
}

func uploadStoreData(
    productsVM: ProductsViewModel,
    newsVM: NewsViewModel,
    proceduresVM: ProceduresViewModel,
    brandsVM: BrandsViewModel) async {
        do {
            try await StorageManager.uploadImagesToStorage()

            await withTaskGroup(of: Void.self) { group in
                group.addTask { await productsVM.uploadProducts() }
                group.addTask { await productsVM.uploadAvailabilityList() }
                group.addTask { await newsVM.uploadNews() }
                group.addTask { await proceduresVM.uploadProcedures() }
                group.addTask { await brandsVM.uploadBrands() }
            }
            
            try await uploadPreviewUserData()
            
            print("Store Data uploaded to Firebase")
        } catch {
            print(error.localizedDescription)
        }
    }
