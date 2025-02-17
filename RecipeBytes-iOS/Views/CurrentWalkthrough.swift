//
//  CurrentWalkthrough.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/6/24.
//

import SwiftUI

struct CurrentWalkthrough: View {
    @State var recipe: Recipe
    @State private var listIndex = 0
    
    var body: some View {
        let instructionSteps = recipe.instructions.split(separator: "\r\n", omittingEmptySubsequences: true)
        
        TabView {
            NavigationStack {
                VStack {
                    Text("Instructions")
                        .font(Font.custom("PatrickHandSC-Regular", size: 40))
                    
                    Spacer()
                    
                    if instructionSteps[listIndex].count > 3 {
                        Text(instructionSteps[listIndex])
                            .font(Font.custom("PatrickHandSC-Regular", size: 20))
                    }
                    
                    HStack {
                        Button {
                            listIndex -= 1
                        } label: {
                            Text("Previous Step")
                        }
                        .disabled(listIndex <= 0)
                        Spacer()
                        Button {
                            listIndex += 1
                        } label: {
                            Text("Next Step")
                        }
                        .disabled(listIndex >= instructionSteps.count - 1)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.logo)
                    .font(Font.custom("PatrickHandSC-Regular", size: 20))

                    Spacer()
                    
                    Text("Swipe → for Instructions List View")
                        .font(Font.custom("PatrickHandSC-Regular", size: 20))
                        .foregroundStyle(.darkerLogo)
                }
            }
            .padding()
            .tag(0)
            
            VStack {
                Text("Instructions")
                    .font(Font.custom("PatrickHandSC-Regular", size: 40))
                
                List {
                    ForEach(0..<instructionSteps.count) { index in
                        if instructionSteps[index].count > 3 {
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundStyle(.logo)
                                    .bold()
                                
                                Text(instructionSteps[index])
                                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                            }
                            .padding()
                        }
                    }
                }
                .listStyle(.plain)
                
                Text("Swipe ← for Instructions Steps")
                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                    .foregroundStyle(.darkerLogo)
                    
            }
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}


#Preview {
    CurrentWalkthrough(recipe: Recipe(id: "52771", name: "Spicy Arrabiata Penne", category: "Vegetarian", cuisine: "Italian", instructions: "Bring a large pot of water to a boil. Add kosher salt to the boiling water, then add the pasta. Cook according to the package instructions, about 9 minutes.\r\nIn a large skillet over medium-high heat, add the olive oil and heat until the oil starts to shimmer. Add the garlic and cook, stirring, until fragrant, 1 to 2 minutes. Add the chopped tomatoes, red chile flakes, Italian seasoning and salt and pepper to taste. Bring to a boil and cook for 5 minutes. Remove from the heat and add the chopped basil.\r\nDrain the pasta and add it to the sauce. Garnish with Parmigiano-Reggiano flakes and more basil and serve warm.", tags: "Pasta,Curry", picture: "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg", strIngredient1: "penne rigate", strIngredient2: "olive oil", strIngredient3: "garlic", strIngredient4: "chopped tomatoes", strIngredient5: "red chilli flakes", strIngredient6: "italian seasoning", strIngredient7: "basil", strIngredient8: "Parmigiano-Reggiano"))
}
