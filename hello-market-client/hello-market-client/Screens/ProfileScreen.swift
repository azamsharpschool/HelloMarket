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
    
    var body: some View {
        Button("Signout") {
            let _ = Keychain<String>.delete("jwttoken")
            userId = nil
            cartStore.emptyCart() 
        }
    }
}

#Preview {
    ProfileScreen()
        .environment(CartStore(httpClient: .development))
}
