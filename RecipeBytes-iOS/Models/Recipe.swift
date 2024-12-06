//
//  Recipe.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/5/24.
//

import Foundation

struct Recipe: Codable, Identifiable {
    var id: String
    var name: String
    var category: String
    var cuisine: String
    var instructions: String
    var tags: String?
    var picture: String
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    var ingredients: [String] {
        [strIngredient1, strIngredient2, strIngredient3, strIngredient4].compactMap { $0 }
    }

    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case cuisine = "strArea"
        case instructions = "strInstructions"
        case tags = "strTags"
        case picture = "strMealThumb"
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20

    }
}

//struct Recipe: Codable, Identifiable {
//    var id: String
//    var name: String
//    var category: String
//    var cuisine: String
//    var instructions: String
//    var picture: String
//    var ingredients: [String]
//    var measures: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case id = "idMeal"
//        case name = "strMeal"
//        case category = "strCategory"
//        case cuisine = "strArea"
//        case instructions = "strInstructions"
//        case picture = "strMealThumb"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        // Decode basic fields
//        id = try container.decode(String.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        category = try container.decode(String.self, forKey: .category)
//        cuisine = try container.decode(String.self, forKey: .cuisine)
//        instructions = try container.decode(String.self, forKey: .instructions)
//        picture = try container.decode(String.self, forKey: .picture)
//        
//        // Decode dynamic fields for ingredients and measures
//        var tempIngredients = [String]()
//        var tempMeasures = [String]()
//
//        for i in 1...20 {
//            if let ingredient = try? container.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: "strIngredient\(i)")!), !ingredient.isEmpty {
//                tempIngredients.append(ingredient)
//            }
//            if let measure = try? container.decodeIfPresent(String.self, forKey: CodingKeys(stringValue: "strMeasure\(i)")!), !measure.isEmpty {
//                tempMeasures.append(measure)
//            }
//        }
//
//        self.ingredients = tempIngredients
//        self.measures = tempMeasures
//    }
//}
