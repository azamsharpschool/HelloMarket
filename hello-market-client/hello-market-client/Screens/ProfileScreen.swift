//
//  ProfileScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/3/24.
//

import SwiftUI

struct ProfileScreen: View {
    
    @AppStorage("userId") private var userId: String?
    @Environment(CartStore.self) private var cartStore
    @Environment(\.showMessage) private var showMessage
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    
    @State private var validationErrors: [String] = []
    
    private func validateForm() -> Bool {
        
        validationErrors = []
        
        if firstName.isEmptyOrWhitespace {
            validationErrors.append("First name is required.")
        }
        if lastName.isEmptyOrWhitespace {
            validationErrors.append("Last name is required.")
        }
        if street.isEmptyOrWhitespace {
            validationErrors.append("Street is required.")
        }
        if city.isEmptyOrWhitespace {
            validationErrors.append("City is required.")
        }
        if state.isEmptyOrWhitespace {
            validationErrors.append("State is required.")
        }
        
        if !zipCode.isZipCode {
            validationErrors.append("Invalid ZIP code.")
        }
        
        return validationErrors.isEmpty
    }
    
    var body: some View {
        
        List {
            Section("Personal Information") {
                TextField("First name", text: $firstName)
                TextField("Last name", text: $lastName)
            }
            
            Section("Address") {
                TextField("Street", text: $street)
                TextField("City", text: $city)
                TextField("State", text: $state)
                TextField("Zipcode", text: $zipCode)
            }
            
            Button("Signout") {
                let _ = Keychain<String>.delete("jwttoken")
                userId = nil
                cartStore.emptyCart()
            }.buttonStyle(.borderless)
           
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if validateForm() {
                        // do something
                    } else {
                        // show message
                        showMessage(validationErrors.joined(separator: "\n"))
                    }
                }
            }
        })
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileScreen()
            .withMessageView()
    }.environment(CartStore(httpClient: .development))
}
