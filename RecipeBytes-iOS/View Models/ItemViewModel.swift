//
//  ItemViewModel.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

@Observable
class ItemViewModel {

    static func saveItem(item: Item, collection: String) async -> String? { // nil if effort failed, otherwise return place.id
        let db = Firestore.firestore()
        
        if let id = item.id { // if true the place exists
            do {
                try db.collection("\(collection)").document(id).setData(from: item)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 ERROR: Could not update data in '\(collection)'. \(error.localizedDescription)")
                return id
            }
        } else { // if false we need to create a new document, and Firebase gives us a unique ID
            do {
                let docRef = try db.collection("\(collection)").addDocument(from: item)
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
        
        db.collection(collection).document(documentID).updateData(["isChecked": newValue]) { error in
            if let error = error {
                print("😡 ERROR: Could not update isChecked for \(item.name). \(error.localizedDescription)")
            } else {
                print("🥳 SUCCESS: updated isChecked for \(item.name)")
            }
        }
    }
    
    static func deleteItem(item: Item, collection: String) {
        let db = Firestore.firestore()
        guard let id = item.id else {
            print("No item.id")
            return
        }
        
        Task {
            do {
                try await db.collection(collection).document(id).delete()
            } catch {
                print("😡 ERROR: Could not delete document \(id)")
            }
        }
    }
    
//    static func fetchCategoryData(for collection: String, category: FoodType, completion: @escaping ([Item]) -> Void) {
//        let db = Firestore.firestore()
//        db.collection(collection).whereField("type", isEqualTo: category.rawValue).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching \(category.rawValue): \(error.localizedDescription)")
//                completion([])
//            } else {
//                let items = snapshot?.documents.compactMap { doc -> Item? in
//                    try? doc.data(as: Item.self)
//                } ?? []
//                completion(items)
//            }
//        }
//    }
//
//    static func fetchAllCategories(collection: String, completion: @escaping ([FoodType: [Item]]) -> Void){
//        var categorizedItems: [FoodType: [Item]] = [:]
//        let group = DispatchGroup()
//
//        for category in FoodType.allCases {
//            group.enter()
//            fetchCategoryData(for: collection, category: category ) { items in
//                categorizedItems[category] = items
//            }
//        }
//        group.notify(queue: .main) {
//                print("Successfully fetched categorized items")
//                completion(categorizedItems)
//            }
//    }
}

