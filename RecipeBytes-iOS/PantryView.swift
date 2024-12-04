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
            Text("Recipe Bytes")
                .font(Font.custom("PatrickHandSC-Regular", size: 40))
                .bold()
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
