//
//  CustomStyle.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/2/24.
//

import Foundation
import SwiftUI

struct CustomStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("PatrickHandSC-Regular", size: 15))
            .foregroundStyle(.white)
            .padding()
            .background(.color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func customStyle() -> some View {
        modifier(CustomStyle())
    }
}
