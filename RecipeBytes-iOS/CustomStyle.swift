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
            .font(Font.custom("PatrickHandSC-Regular", size: 20))
            .foregroundStyle(.white)
            .padding(15)
            .background(.logo)
            .frame(maxHeight: 23)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func customStyle() -> some View {
        modifier(CustomStyle())
    }
}
