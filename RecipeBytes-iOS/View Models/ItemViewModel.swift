//
//  ItemViewModel.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

@Observable
class ItemViewModel {
    
    static func saveItem(item: Item, collection: String) async -> String? { // nil if effort failed, otherwise return place.id
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            print("😡 ERROR: Could not retrieve current user")
            return nil
        }
        
        if let id = item.id { // if true the place exists
            do {
                try db.collection("users").document(user.uid).collection(collection).document(id).setData(from: item)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 ERROR: Could not update data in '\(collection)'. \(error.localizedDescription)")
                return id
            }
        } else { // if false we need to create a new document, and Firebase gives us a unique ID
            do {
                let docRef = try db.collection("users").document(user.uid).collection(collection).addDocument(from: item)
                print("🐣 Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new place in '\(collection)'. \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func toggleCheck(item: Item, collection: String) {
        guard let documentID = item.id else {
            print("😡 ERROR: Could not retrieve item id for \(item.name)")
            return
        }
        
        let db = Firestore.firestore()
        let newValue = !item.isChecked
        guard let user = Auth.auth().currentUser else {
            print("😡 ERROR: Could not retrieve current user")
            return
        }
        
        db.collection("users").document(user.uid).collection(collection).document(documentID).updateData(["isChecked": newValue]) { error in
            if let error = error {
                print("😡 ERROR: Could not update isChecked for \(item.name). \(error.localizedDescription)")
            } else {
                print("🥳 SUCCESS: updated isChecked for \(item.name)")
            }
        }
    }
    
    static func deleteItem(item: Item, collection: String) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            print("😡 ERROR: Could not retrieve current user")
            return
        }
        guard let id = item.id else {
            print("No item.id")
            return
        }
        
        Task {
            do {
                try await db.collection("users").document(user.uid).collection(collection).document(id).delete()
            } catch {
                print("😡 ERROR: Could not delete document \(id)")
            }
        }
    }
    
    static func refreshUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        user.reload() { error in
            if let error = error {
                print("😡 ERROR: problem reloading user data: \(error.localizedDescription)")
            } else {
                print("😀 User data reloaded successfully!")
            }
        }
    }
    
    static func moveItem(items: [Item], from sourceCollection: String, to targetCollection: String) async -> Bool {
        let db = Firestore.firestore()
        
        ItemViewModel.refreshUserProfile()
        
        // Ensure the user is authenticated
        guard let user = Auth.auth().currentUser else {
            print("😡 ERROR: Could not retrieve current user")
            return false
        }
        
        // Fetch the document from the source collection
        for item in items {
            do {
                guard let id = item.id else {
                    print("😡 ERROR: Could not retrieve item")
                    return false
                }
                
                let sourceDocRef = db.collection("users").document(user.uid).collection(sourceCollection).document(id)
                let snapshot = try await sourceDocRef.getDocument()
                
                guard snapshot.exists, let data = snapshot.data() else {
                    print("😡 ERROR: Document with ID \(id) not found in \(sourceCollection).")
                    return false
                }
                
                // Create a new document in the target collection
                let targetDocRef = db.collection("users").document(user.uid).collection(targetCollection).document(id)
                try await targetDocRef.setData(data)
                print("😀 Item successfully moved to \(targetCollection).")
                
                // Step 3: Delete the document from the source collection
                try await sourceDocRef.delete()
                print("😀 Item successfully removed from \(sourceCollection).")
                
            } catch {
                print("😡 ERROR: Could not move item. \(error.localizedDescription)")
                return false
            }
        }
        return true
    }
    
    static func getCheckedItems(collection: String, completion: @escaping (Result<[Item], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection(collection)
            .whereField("isChecked", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("😡 ERROR: could not retrieve documents from '\(collection)' collection. \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let querySnapshot = querySnapshot {
                    var items: [Item] = []
                    
                    for document in querySnapshot.documents {
                        do {
                            let item = try document.data(as: Item.self)
                            items.append(item)
                        } catch {
                            print("😡 ERROR: Could not decode document \(error.localizedDescription)")
                        }
                    }
                    
                    completion(.success(items))
                }
            }
    }
    
}

