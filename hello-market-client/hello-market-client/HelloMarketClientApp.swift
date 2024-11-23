//
//  hello_market_clientApp.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import SwiftUI
import UIKit
import JWTDecode

@main
struct HelloMarketClientApp: App {
    
    @State private var productStore = ProductStore(httpClient: HTTPClient())
    @State private var cartStore = CartStore(httpClient: HTTPClient())
    @State private var userStore = UserStore(httpClient: HTTPClient())
    
    @AppStorage("userId") private var userId: String?
    
    private func fetchUserInfoAndCart() async {
        do {
            try await cartStore.loadCart()
            try await userStore.loadUserInfo()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
            .environment(productStore)
            .environment(cartStore)
            .environment(userStore)
            .environment(\.authenticationController, AuthenticationController(httpClient: .development))
            .environment(\.uploaderDownloader, ImageUploaderDownloader(httpClient: .development))
            .withMessageView()
            .task(id: userId) {
                if userId != nil {
                    await fetchUserInfoAndCart()
                }
            }
        }
    }
}


