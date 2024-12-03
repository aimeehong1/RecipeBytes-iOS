//
//  ProfileView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/1/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var displayName = ""
    @State private var email = Auth.auth().currentUser?.email ?? ""
    @State private var textFieldsDisabled = true
    var body: some View {
        VStack(alignment: .center) {
            Text("Recipe Bytes")
                .font(Font.custom("PatrickHandSC-Regular", size: 40))
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(.color)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 160, height: 160)
                .scaledToFill()
                .clipped()
            
            Spacer()
            
            HStack {
                Text("Name")
                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                TextField("", text: $displayName)
                    .disabled(textFieldsDisabled)
                    .textFieldStyle(.roundedBorder)
                    .tint(.color)
            }
            .bold()
            .padding()
            
            HStack {
                Text("Email")
                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                TextField("", text: $email)
                    .disabled(textFieldsDisabled)
                    .textFieldStyle(.roundedBorder)
                    .tint(.color)
            }
            .bold()
            .padding(.horizontal)
            
            if !textFieldsDisabled {
                Button("Save") {
                    textFieldsDisabled = true
//                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//                    changeRequest?.displayName = displayName
//                    changeRequest?.commitChanges { (error) in
//                      // ...
//                    }
                }
                .buttonStyle(.bordered)
                .tint(.black)
                .font(Font.custom("PatrickHandSC-Regular", size: 20))
                .frame(height: 15)
            }
            
            Spacer()
            
            HStack {
                Button("Update Profile") {
                    textFieldsDisabled.toggle()
                    
                }
                Button("Sign Out") {
                    do {
                        try Auth.auth().signOut()
                        print("🪵➡️ Log out successful!")
                        dismiss()
                        
                    } catch {
                        print("😡 ERROR: Could not sign out!")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.color)
            .font(Font.custom("PatrickHandSC-Regular", size: 22))
            
            Spacer()
        }
    }
}

#Preview {
    ProfileView()
}
