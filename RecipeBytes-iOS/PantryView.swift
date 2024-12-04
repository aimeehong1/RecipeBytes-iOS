//
//  PantryView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/3/24.
//

import SwiftUI

struct PantryView: View {
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
            
            Spacer()
        }
    }
}

#Preview {
    PantryView()
}
