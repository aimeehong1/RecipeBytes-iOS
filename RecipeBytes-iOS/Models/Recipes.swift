//
//  Recipes.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/5/24.
//

import Foundation

@Observable
class Recipes {
    private struct Returned: Codable {
        var meals: [Recipe]
    }
    
    var urlString = "https://www.themealdb.com/api/json/v1/1/random.php"
    var meals: [Recipe] = []
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: could not create a URL from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // try to decode JSON data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: could not decode returned JSON data")
                return
            }

            Task { @MainActor in
                self.meals = Array(Set(returned.meals + self.meals))
                print("Returned \(returned)")
                await loadList()
            }
        } catch {
            print("😡 ERROR: could not get data from \(urlString)")
        }
    }
    
    func loadList() async {
        while meals.count < 15 {
            await getData()
        }
    }
}

