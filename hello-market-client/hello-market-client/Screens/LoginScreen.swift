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
    
    @State private var username: String = "johndoe"
    @State private var password: String = "password"
    @State private var message: String?
    @State private var isLoading: Bool = false
    @State private var isLoggedIn: Bool = false
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
        
            Form {
                TextField("User name", text: $username)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                HStack {
                    Button("Login") {
                        Task {
                            await login()
                        }
                    }.disabled(!isFormValid)
                    
                    Spacer()
                    Button("Register") {
                        isRegistrationPresented = true
                    }
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
