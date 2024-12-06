//
//  ProfileViewModel.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

@Observable
class ProfileViewModel {
    var displayName: String = ""
    var photoURL: URL?
    
    static func updateUserName(displayName: String) async {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        
        do {
            try await changeRequest.commitChanges()
            print("😀 SUCCESS: Profile updated successfully!")
        } catch {
            print("😡 ERROR: problem updating user's display name. \(error.localizedDescription)")
        }
    }
    
    static func updateUserPhoto(photoURL: URL?) async {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        
        if let photoURL = photoURL {
            changeRequest.photoURL = photoURL
        }
        do {
            try await changeRequest.commitChanges()
            print("😀 SUCCESS: Profile updated successfully!")
        } catch {
            print("😡 ERROR: problem updating user's display name. \(error.localizedDescription)")
        }
    }
    
    static func refreshUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reload() { error in
            if let error = error {
                print("😡 ERROR: problem reloading user data: \(error.localizedDescription)")
            } else {
                print("😀 User data reloaded successfully!")
                if let displayName = user.displayName {
                    print("Updated profile name: \(displayName)")
                }
            }
        }
    }
    
    static func saveImage(data: Data) async -> URL? {
        guard let user = Auth.auth().currentUser else {
            print("😡 ERROR: Could not get current user")
            return nil
        }
        let id = user.uid
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let path = "user_photos/\(id)"
        do {
            let storageref = storage.child(path)
            let _ = try await storageref.putDataAsync(data, metadata: metadata)
            print("😎 SAVED: Photo named \(id)")
            // get URL taht we'll use to load the image
            guard let url = try? await storageref.downloadURL() else {
                print("😡 ERROR: could not get downloadURL")
                return nil
            }
            // save the url to the Firestore database (cloud Firestore)
            let displayName = user.displayName ?? "Anonymous"
            await ProfileViewModel.updateUserPhoto(photoURL: url)
            print("Updated profileURL: \(url)")
            
            // Save the URL to Firestore
            let db = Firestore.firestore()
            do {
                try await db.collection("users").document(id).setData(["photoURL": url.absoluteString], merge: true)
                return url
            } catch {
                print("😡 ERROR: could not update Firestore document \(id). Error: \(error.localizedDescription)")
                return nil
            }
        } catch {
            print("😡 ERROR: saving photo to Storage \(error.localizedDescription)")
            return nil
        }
    }
}
