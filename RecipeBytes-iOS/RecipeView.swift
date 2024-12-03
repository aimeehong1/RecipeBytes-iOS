//
//  RecipeView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 11/25/24.
//

import SwiftUI

struct RecipeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Recipe Bytes")
                    .font(Font.custom("PatrickHandSC-Regular", size: 40))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.color)
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        
                    } label: {
                        VStack {
                            Image(systemName: "fork.knife.circle")
                            Text("Recipes")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        
                    } label: {
                        VStack {
                            Image(systemName: "list.bullet.clipboard")
                            Text("Grocery List")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        
                    } label: {
                        VStack {
                            Image(systemName: "carrot")
                            Text("Pantry Tracker")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        VStack {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                    }
                }
            }
            .tint(.color)
        }
    }
}

#Preview {
    RecipeView()
}
