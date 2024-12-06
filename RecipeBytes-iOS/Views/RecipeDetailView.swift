//
//  RecipeDetailView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/5/24.
//

import SwiftUI

struct RecipeDetailView: View {
    @State var recipe: Recipe
    //    private let pages: [any View] = [ingredientView, instructions]
    @State var ingredients: [Item] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                AsyncImage(url: URL(string: recipe.picture)) { image in
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                        .scaledToFill()
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.gray, lineWidth: 2)
                        )
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                        .scaleEffect(4)
                        .tint(.logo)
                }
                
                Text(recipe.name)
                    .font(Font.custom("PatrickHandSC-Regular", size: 30))
                
                HStack {
                    Text(recipe.category)
                        .customStyle()
                    if recipe.cuisine != "Unknown" {
                        Text(recipe.cuisine)
                            .customStyle()
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                List {
                    Text("Ingredients")
                    ScrollView {
                        ForEach(ingredients) { ingredient in
                            HStack {
                                Image(systemName: ingredient.isChecked ? "checkmark.square" : "square")
                                
                                Text(ingredient.name)
                                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                            }
                            .padding()
                        }
                    }
                }
                .background(.logo.opacity(0.3))
                .font(Font.custom("PatrickHandSC-Regular", size: 20))
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            CurrentWalkthrough(recipe: recipe)
                        } label: {
                            VStack {
                                Text("Walkthrough")
                                Image(systemName: "arrowshape.right.circle")
                            }
                        }
                    }
                }
                .font(Font.custom("PatrickHandSC-Regular", size: 20))
                .tint(.logo)
            }
        }
        .task {
            loadIngredients()
        }
    }
    func loadIngredients() {
        let recipeIngredients = recipe.ingredients
        ingredients = recipeIngredients.map { Item(name: $0) }
        print(ingredients)
    }
}

#Preview {
    RecipeDetailView(recipe: Recipe(id: "52771", name: "Spicy Arrabiata Penne", category: "Vegetarian", cuisine: "Italian", instructions: "Bring a large pot of water to a boil. Add kosher salt to the boiling water, then add the pasta. Cook according to the package instructions, about 9 minutes.\r\nIn a large skillet over medium-high heat, add the olive oil and heat until the oil starts to shimmer. Add the garlic and cook, stirring, until fragrant, 1 to 2 minutes. Add the chopped tomatoes, red chile flakes, Italian seasoning and salt and pepper to taste. Bring to a boil and cook for 5 minutes. Remove from the heat and add the chopped basil.\r\nDrain the pasta and add it to the sauce. Garnish with Parmigiano-Reggiano flakes and more basil and serve warm.", tags: "Pasta,Curry", picture: "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg", strIngredient1: "penne rigate", strIngredient2: "olive oil", strIngredient3: "garlic", strIngredient4: "chopped tomatoes", strIngredient5: "red chilli flakes", strIngredient6: "italian seasoning", strIngredient7: "basil", strIngredient8: "Parmigiano-Reggiano"))
}
