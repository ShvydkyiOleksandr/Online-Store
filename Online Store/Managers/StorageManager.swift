//
//  StorageManager.swift
//  Online Store
//
//  Created by Олександр Швидкий on 24.01.2023.
//

import Foundation
import FirebaseStorage
import UIKit.UIImage

final class StorageManager {
    static var storageRef = Storage.storage().reference()
    private static var avatarsRef: StorageReference { storageRef.child("avatars") }
    
    static func uploadProfileImage(imageData: Data, userEmail: String) async throws -> String {
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let imageData = try scaleImage(imageData: imageData)
        do {
            _ = try await avatarsRef.child(userEmail).putDataAsync(imageData, metadata: metadata)
            do {
                let url = try await avatarsRef.child(userEmail).downloadURL()
                return url.absoluteString
            } catch {
                print("Error fetching avatarUrl from firebase: \(error.localizedDescription)")
                throw CustomError.savingUser()
            }
        } catch {
            print("Error uploading avatarData to firebase: \(error.localizedDescription)")
            throw CustomError.savingUser()
        }
    }
    
    static func uploadImage(imageData: Data, ref: StorageReference, id: String) async throws -> String {
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        do {
            _ = try await ref.child(id).putDataAsync(imageData, metadata: metadata)
            do {
                let url = try await ref.child(id).downloadURL()
                return url.absoluteString
            } catch {
                print("Error downloading image url: \(error.localizedDescription)")
                throw CustomError.savingImageError
            }
        } catch {
            print(error.localizedDescription)
            throw CustomError.savingImageError
        }
    }
    
    static private func scaleImage(imageData: Data) throws -> Data {
        guard let starImage = UIImage(data: imageData) else { throw CustomError.savingUser() }
        let scaledImage = starImage.resized(to: CGSize(width: 100, height: 100))
        guard let jpegData = scaledImage.jpegData(compressionQuality: 1) else { throw CustomError.savingUser() }
        return jpegData
    }
}
