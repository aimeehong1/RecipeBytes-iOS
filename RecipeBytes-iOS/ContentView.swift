//
//  ContentView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            RecipeView()
                .tabItem {
                    Image(systemName: "frying.pan")
                    Text("Recipes")
                }
            GroceryView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Grocery List")
                }
            PantryView()
                .tabItem {
                    Image(systemName: "carrot")
                    Text("Pantry Tracker")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(.logo)
        .task {
            ProfileViewModel.refreshUserProfile()
        }
    }
}

#Preview {
    ContentView()
}
