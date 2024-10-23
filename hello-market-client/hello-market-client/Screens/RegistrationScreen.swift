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
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5))
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10) // for spacing

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5))
                )
                .padding(.bottom, 20) // for spacing

            Button(action: {
                Task {
                    await register()
                }
            }) {
                Text("Register")
                    .bold()
                    .frame(maxWidth: .infinity) // makes it fill the width
                    .padding()
                    .background(isFormValid ? Color.purple : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isFormValid)
            .padding(.vertical, 10)
            .buttonStyle(.borderless)
            
            
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
