//
//  Item.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import Foundation
import FirebaseFirestore

enum FoodType: String, CaseIterable, Codable {
    case produce, protein, dairy, grains, other
}

struct Item: Codable, Identifiable, Equatable, Hashable {
    @DocumentID var id: String?
    var name = ""
    var quantity = 0
    var type: FoodType = .produce
    var expirationDate = Date()
    var isChecked = false
}
