//
//  RecipeView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 11/25/24.
//

import SwiftUI
import FirebaseAuth

struct RecipeView: View {
    @State private var displayName = Auth.auth().currentUser?.displayName
    @State var recipes = Recipes()
    @State private var searchText = ""
    @State private var profileVM = ProfileViewModel()
    
    var body: some View {
        
        VStack {
            HStack {
                VStack {
                    Text("Explore Recipes")
                }
                .bold()
                Image(systemName: "fork.knife.circle")
            }
            .font(Font.custom("PatrickHandSC-Regular", size: 30))
            .padding()
            .frame(maxWidth: .infinity)
            .background(.logo)
            .foregroundStyle(.white)
            
            NavigationStack {
                List(recipes.meals) { meal in
                    NavigationLink {
                        RecipeDetailView(recipe: meal)
                    } label: {
                        Text("\(returnIndex(of: meal)). ")
                            .foregroundStyle(.logo)
                        Text(meal.name)
                    }
                }
                .listStyle(.plain)
                .font(Font.custom("PatrickHandSC-Regular", size: 22))
                .searchable(text: $searchText)
            }
        }
        .task {
            await recipes.getData()
        }
    }
    
    func returnIndex(of recipe: Recipe) -> Int {
        guard let index = recipes.meals.firstIndex(where: { $0.id == recipe.id }) else {return 0}
        return index + 1
    }
}

#Preview {
    RecipeView()
}
