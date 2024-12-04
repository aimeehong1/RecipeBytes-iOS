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
                Text("Recipe Bytes")
                    .font(Font.custom("PatrickHandSC-Regular", size: 40))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.color)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Hello \(Auth.auth().currentUser?.displayName ?? "Guest")!")
                    .customStyle()
                
                Spacer()
            }
        }
    }
}

#Preview {
    RecipeView()
}
