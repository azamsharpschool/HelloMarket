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
    @Environment(UserStore.self) private var userStore
    
    @Environment(\.showMessage) private var showMessage
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    
    @State private var validationErrors: [String] = []
    @State private var updatingUserInfo: Bool = false
    
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
    
    private func updateUserInfo() async {
        
        do {
            let userInfo = UserInfo(firstName: firstName, lastName: lastName, street: street, city: city, state: state, zipCode: zipCode)
            try await userStore.updateUserInfo(userInfo: userInfo)
        } catch {
            print(error.localizedDescription.localizedLowercase)
        }
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        let _ = print(userStore.userInfo)
        
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
                userStore.userInfo = nil 
            }.buttonStyle(.borderless)
        }
        .onChange(of: userStore.userInfo, initial: true, {
            if let userInfo = userStore.userInfo {
                firstName = userInfo.firstName
                lastName = userInfo.lastName
                street = userInfo.street
                city = userInfo.city
                state = userInfo.state
                zipCode = userInfo.zipCode
            }
        })
        
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if validateForm() {
                        updatingUserInfo = true
                    } else {
                        // show message
                        showMessage(validationErrors.joined(separator: "\n"))
                    }
                }
            }
        })
        .task(id: updatingUserInfo, {
            if updatingUserInfo {
                await updateUserInfo()
            }
            
            updatingUserInfo = false 
        })
        .navigationTitle("Profile")
    }
}

#Preview {
    
    NavigationStack {
        ProfileScreen()
            .withMessageView()
    }
    .environment(CartStore(httpClient: .development))
    .environment(UserStore(httpClient: .development))
}
