//
//  GroceryView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import SwiftUI

struct GroceryView: View {
    var body: some View {
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
            .background(.color)
            .foregroundStyle(.white)
            
            ScrollView {
                VStack {
                    Text("Grocery List")
                        .font(Font.custom("PatrickHandSC-Regular", size: 25))

                    List {
                        Section {
                            Text("Potatoes 🥔")
                            Text("Produce")
                        } header: {
                            Text("Produce")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GroceryView()
}
