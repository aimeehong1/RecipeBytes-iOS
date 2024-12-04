//
//  RecipeView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 11/25/24.
//

import SwiftUI
import FirebaseAuth

struct RecipeView: View {
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
                
                Text("Hello \(Auth.auth().currentUser?.displayName?.split(separator: " ")[0] ?? "Guest")!")
                    .customStyle()
                
                Spacer()
            }
        }
    }
}

#Preview {
    RecipeView()
}
