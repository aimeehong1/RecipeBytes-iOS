//
//  LoginView.swift
//  RecipeBytes-iOS
//
//  Created by Aimee Hong on 12/1/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var displayName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var presentSheet = false
    @State private var loginShown = true
    @State private var invalidEmail = false
    @State private var invalidPassword = false
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack {
            Text("Recipe Bytes")
                .font(Font.custom("PatrickHandSC-Regular", size: 40))
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(.logo)
                .foregroundStyle(.white)
            
            Spacer()
            
            Image("login")
                .resizable()
                .scaledToFit()
                .padding()
            
            Spacer()
            
            Text(loginShown ? "Login" : "Sign Up")
                .font(Font.custom("PatrickHandSC-Regular", size: 30))
            
            if loginShown {
                Group {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email) // this field is bound to the .email case
                        .onSubmit {
                            focusField = .password
                        }
                    
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .focused($focusField, equals: .password) // this field is bound to the .password case
                        .onSubmit {
                            focusField = nil // will dismiss the keyboard
                        }
                }
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                .padding(.horizontal)
                
                HStack {
                    Button {
                        login()
                    } label: {
                        Text("Log In")
                    }
                    .padding(.trailing)
                    
                    Text("or")
                    
                    Button {
                        loginShown = false
                    } label: {
                        Text("Go to Sign Up")
                    }
                    .padding(.leading)
                }
                .buttonStyle(.borderedProminent)
                .font(Font.custom("PatrickHandSC-Regular", size: 20))
                .padding(.top)
                .tint(.logo)
            } else {
                Group {
                    TextField("Name", text: $displayName)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email) // this field is bound to the .email case
                        .onSubmit {
                            focusField = .password
                        }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email) // this field is bound to the .email case
                        .onSubmit {
                            focusField = .password
                        }
                    
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                        .focused($focusField, equals: .password) // this field is bound to the .password case
                        .onSubmit {
                            focusField = nil // will dismiss the keyboard
                        }
                }
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                .padding(.horizontal)
                
                if invalidEmail {
                    Text("Invalid Email")
                        .foregroundStyle(.red)
                        .bold()
                }
                if invalidPassword {
                    Text("Password must be at least 6 characters")
                        .foregroundStyle(.red)
                        .bold()
                }
                
                HStack {
                    Button {
                        invalidEmail = false
                        invalidPassword = false
                        alertMessage = ""
                        register()
                    } label: {
                        Text("Sign Up")
                    }
                    .padding(.trailing)
                    
                    Text("or")
                    
                    Button {
                        loginShown = true
                    } label: {
                        Text("Go to Login")
                    }
                    .padding(.leading)
                }
                .buttonStyle(.borderedProminent)
                .font(Font.custom("PatrickHandSC-Regular", size: 20))
                .padding(.top)
                .tint(.logo)
            }
            
            Spacer()
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            // if logged in when app runs, navigate to the new screen & skip login screen
            if Auth.auth().currentUser != nil {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet) {
            ContentView()
        }
    }
    
    func register() {
        validateInputs()
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error { // login error occurred
                print("😡 SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎 Registration success!")
                Task {
                    await ProfileViewModel.updateUserProfile(displayName: displayName, photoURL: URL(string: ""))
                    presentSheet = true
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error { // login error occurred
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Login Successful!")
                presentSheet = true
            }
        }
    }
    
    func validateInputs() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        if !emailIsGood {
            invalidEmail = true
            alertMessage = "Invalid email"
            showingAlert = true
        }
        if !passwordIsGood {
            invalidPassword = true
            if alertMessage == "" {
                alertMessage += "Password must be at least 6 characters"
            } else {
                alertMessage += " and password must be at least 6 characters"
            }
            showingAlert = true
        }
        if !(emailIsGood && passwordIsGood) { return }
    }
}

#Preview {
    LoginView()
}
