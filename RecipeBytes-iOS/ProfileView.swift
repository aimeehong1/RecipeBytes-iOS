//
//  ProfileView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/1/24.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import PhotosUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var data = Data()
    @State private var displayName = "Guest"
    @State private var email = Auth.auth().currentUser?.email ?? ""
    @State private var textFieldsDisabled = true
    @State private var selectedImage = Image(systemName: "person.crop.circle")
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var pickerIsPresented = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Recipe Bytes")
                    .font(Font.custom("PatrickHandSC-Regular", size: 40))
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.color)
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack {
                    AsyncImage(url: Auth.auth().currentUser?.photoURL) { image in
                        image
                            .resizable()
                            .frame(width: 160, height: 160)
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                    } placeholder: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 160, height: 160)
                            .scaledToFill()
                            .clipShape(Circle())
                    }

                    if !textFieldsDisabled {
                        Button("Change Image") {
                            pickerIsPresented.toggle()
                            textFieldsDisabled.toggle()
                        }
                        .buttonStyle(.bordered)
                        .tint(.color)
                        .frame(height: 20)
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Name")
                        .font(Font.custom("PatrickHandSC-Regular", size: 20))
                    TextField("", text: $displayName)
                        .disabled(textFieldsDisabled)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(textFieldsDisabled ? .color : .black)
                }
                .bold()
                .padding()
                
                HStack {
                    Text("Email")
                        .font(Font.custom("PatrickHandSC-Regular", size: 20))
                    TextField("", text: $email)
                        .disabled(true)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.color)
                }
                .bold()
                .padding(.horizontal)
                
                if !textFieldsDisabled {
                    Button("Save") {
                        textFieldsDisabled = true
                        ProfileViewModel.updateUserProfile(displayName: displayName, photoURL: URL(string: ""))
                        ProfileViewModel.refreshUserProfile()
                    }
                    .buttonStyle(.bordered)
                    .tint(.black)
                    .font(Font.custom("PatrickHandSC-Regular", size: 15))
                    .frame(height: 15)
                } else { // placeholder so the buttons don't shift down
                    Button("Save") {
                    }
                    .frame(height: 15)
                    .hidden()
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
        .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
        .onChange(of: selectedPhoto) {
            Task {
                do {
                    if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                        selectedImage = image
                    }
                    // Let's get data from the selectedPhoto
                    guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                        print("😡 ERROR: Could not convert selectedPhoto into data")
                        return
                    }
                    data = transferredData
                    let imageURL = await ProfileViewModel.saveImage(data: data)
                    if let imageURL = imageURL {
                        ProfileViewModel.updateUserProfile(displayName: displayName, photoURL: imageURL)
                        ProfileViewModel.refreshUserProfile()
                    } else {
                        print("😡 ERROR: Could not save image and update profile.")
                    }
                } catch {
                    print("😡 ERROR: COuld not create Image from selectedPhoto \(error.localizedDescription)")
                }
            }
        }
        .task {
            ProfileViewModel.refreshUserProfile()
            displayName = Auth.auth().currentUser?.displayName ?? "Guest"
        }
    }
}

#Preview {
    ProfileView()
}
