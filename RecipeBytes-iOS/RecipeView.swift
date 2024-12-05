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
    @State private var profileVM = ProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack {
                        Text("Recipe Bytes")
                    }
                    .bold()
                    Image(systemName: "fork.knife.circle")
                }
                .font(Font.custom("PatrickHandSC-Regular", size: 30))
                .padding()
                .frame(maxWidth: .infinity)
                .background(.logo)
                .foregroundStyle(.white)
                
                Spacer()
                
                Text("Hello \(displayName?.split(separator: " ")[0] ?? "Guest")!")
                    .customStyle()
                
                Spacer()
            }
        }
        .task {
            profileVM.refreshUserProfile()
            displayName = Auth.auth().currentUser?.displayName ?? "Guest"
        }
    }
}

#Preview {
    RecipeView()
}
