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
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    
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
                    
                }
            }
        })
        .navigationTitle("Profile")
        
        
        /*
        Button("Signout") {
            let _ = Keychain<String>.delete("jwttoken")
            userId = nil
            cartStore.emptyCart() 
        }.navigationTitle("Profile")
         */
    }
}

#Preview {
    NavigationStack {
        ProfileScreen()
    }.environment(CartStore(httpClient: .development))
}
