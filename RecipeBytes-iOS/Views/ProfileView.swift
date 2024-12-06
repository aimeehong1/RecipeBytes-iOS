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
//    @State private var profileVM = ProfileViewModel()
    var currentUser: User? {
        Auth.auth().currentUser
    }
    
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
                
                if let photoURL = currentUser?.photoURL {
                    AsyncImage(url: currentUser?.photoURL) { image in
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
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .scaledToFill()
                }
                
                if !textFieldsDisabled {
                    Button("Change Image") {
                        Task {
                            await handleSelectedPhoto()
                            pickerIsPresented.toggle()
                        }
                        textFieldsDisabled.toggle()
                    }
                    .buttonStyle(.bordered)
                    .tint(.logo)
                    .frame(height: 20)
                    .padding(.top)
                    .font(Font.custom("PatrickHandSC-Regular", size: 20))
                } else { // prevent view from shifting up and down
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
                            Task {
                                await ProfileViewModel.updateUserName(displayName: displayName)
                            }
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
                        ProfileViewModel.refreshUserProfile()
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
                await handleSelectedPhoto()
            }
        }
        .onAppear() {
            textFieldsDisabled = true
            ProfileViewModel.refreshUserProfile()
            displayName = currentUser?.displayName ?? "Guest"
        }
    }
    
    func handleSelectedPhoto() async {
        do {
            // Let's get data from the selectedPhoto
            guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                print("😡 ERROR: Could not convert selectedPhoto into data")
                return
            }
            data = transferredData
            if let imageURL = await ProfileViewModel.saveImage(data: data) {
                await ProfileViewModel.updateUserPhoto(photoURL: imageURL)
                Auth.auth().currentUser?.reload { error in
                    if let error = error {
                        print("😡 ERROR: Could not reload user: \(error.localizedDescription)")
                    } else {
                        ProfileViewModel.refreshUserProfile()
                    }
                }
            } else {
                print("😡 ERROR: Could not save image and update profile.")
            }
        } catch {
            print("😡 ERROR: COuld not create Image from selectedPhoto \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    ProfileView()
}
