//
//  LoginScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import SwiftUI

struct LoginScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController
    @Environment(\.showMessage) private var showMessage
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String?
    @State private var isLoading: Bool = false
    @State private var isRegistrationPresented: Bool = false
    @AppStorage("userId") private var userId: Int?
    
    private var isFormValid: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func login() async {
        
        message = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await authenticationController.login(username: username, password: password)
            
            guard let token = response.token,
                  let userId = response.userId, response.success else {
                
                showMessage(response.message ?? "Unable to login")
                return
            }
            
            // set the keychain
            Keychain.set(token, forKey: "jwttoken")
            // set the user defaults
            self.userId = userId
            dismiss()
            
        } catch {
            showMessage(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text("Don't have an account?")
                Button("Register") {
                    isRegistrationPresented = true
                }.foregroundColor(.blue)
            }
            .font(.subheadline)
            .padding([.bottom, .top], 20)
            
            Form {
                TextField("User name", text: $username)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5))
                    )
                
                PasswordField(password: $password)
                
                HStack {
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Login")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.purple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                }.buttonStyle(.borderless)
                
            } .sheet(isPresented: $isRegistrationPresented, content: {
                NavigationStack {
                    RegistrationScreen()
                        .withMessageView()
                }
            })
            .navigationTitle("Login")
            .overlay(alignment: .center) {
                if isLoading {
                    ProgressView("Loading...")
                }
            }
        }
        
        
        
        
    }
}

struct LoginScreenContainer: View {
    
    var body: some View {
        NavigationStack {
            LoginScreen()
        }
        .environment(\.authenticationController, .development)
        .withMessageView()
        .environment(ProductStore(httpClient: .development))
    }
}

#Preview {
    LoginScreenContainer()
}
