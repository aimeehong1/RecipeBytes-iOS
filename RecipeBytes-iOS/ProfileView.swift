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
                
                if Auth.auth().currentUser?.photoURL == nil {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .scaledToFill()
                } else {
                    AsyncImage(url: Auth.auth().currentUser?.photoURL) { image in
                        image
                            .resizable()
                            .frame(width: 180, height: 180)
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(.black, lineWidth: 2)
                            )
                    } placeholder: {
                        ProgressView()
                            .scaleEffect(4)
                            .tint(.logo)
                    }
                }
                if !textFieldsDisabled {
                    Button("Change Image") {
                        pickerIsPresented.toggle()
                        textFieldsDisabled.toggle()
                    }
                    .buttonStyle(.bordered)
                    .tint(.logo)
                    .frame(height: 20)
                    .padding(.top)
                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                } else {
                    Button("") { }
                        .frame(height: 20)
                        .padding(.top)
                }
                
                Spacer()
                
                HStack {
                    Text("Name")
                        .font(Font.custom("PatrickHandSC-Regular", size: 20))
                    
                    TextField("", text: $displayName)
                        .disabled(textFieldsDisabled)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(textFieldsDisabled ? .logo : .black)
                        .font(Font.custom("PatrickHandSC-Regular", size: 20))
                    
                    if !textFieldsDisabled {
                        Button("Save") {
                            textFieldsDisabled = true
                            ProfileViewModel.updateUserProfile(displayName: displayName, photoURL: URL(string: ""))
                            ProfileViewModel.refreshUserProfile()
                        }
                        .buttonStyle(.bordered)
                        .tint(.logo)
                        .font(Font.custom("PatrickHandSC-Regular", size: 15))
                        .frame(height: 15)
                    }
                }
                .bold()
                .padding()
                
                HStack {
                    Text("Email")
                    
                    TextField("", text: $email)
                        .disabled(true)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(.logo)
                }
                .bold()
                .padding(.horizontal)
                .font(Font.custom("PatrickHandSC-Regular", size: 20))
                
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
                .tint(.logo)
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
