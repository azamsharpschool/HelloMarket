//
//  ContentView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @Environment(\.showMessage) private var showMessage
    @Environment(\.authenticationController) private var authenticationController
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    private var isFormValid: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func register() async {
        do {
            let response = try await authenticationController.register(username: username, password: password)
            if response.success {
                // dismiss the current screen
                dismiss() 
            } else {
                showMessage(response.message ?? "")
            }
            
        } catch {
            showMessage(error.localizedDescription)
        }
    }
    
    var body: some View {
        Form {
            TextField("User name", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Register") {
                Task {
                    await register()
                }
            }.disabled(!isFormValid)
            .buttonStyle(.borderless)
            
            Text(message)
        }
        .navigationTitle("Register")
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
          
    }
    .environment(\.authenticationController, .development)
    .withMessageView()
    
}
