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
    var picture: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case cuisine = "strArea"
        case instructions = "strInstructions"
        case picture = "strMealThumb"

    }
}
