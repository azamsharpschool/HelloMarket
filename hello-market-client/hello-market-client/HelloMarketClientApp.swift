//
//  hello_market_clientApp.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import SwiftUI
import UIKit
import JWTDecode
@preconcurrency import Stripe

@main
struct HelloMarketClientApp: App {
    
    @State private var productStore = ProductStore(httpClient: HTTPClient())
    @State private var cartStore = CartStore(httpClient: HTTPClient())
    @State private var userStore = UserStore(httpClient: HTTPClient())
    @State private var authenticationController = AuthenticationController(httpClient: HTTPClient())
    @State private var paymentController = PaymentController(httpClient: HTTPClient())
    @State private var orderStore = OrderStore(httpClient: HTTPClient())
    
    @AppStorage("userId") private var userId: String?
    
    init() {
        StripeAPI.defaultPublishableKey = ProcessInfo.processInfo.environment["STRIPE_PUBLISHABLE_KEY"] ?? ""
    }
    
    private func loadUserInfoAndCart() async {
        
        await cartStore.loadCart()
        
        do {
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
            .environment(orderStore)
            .environment(\.authenticationController, authenticationController)
            .environment(\.paymentController, paymentController)
            .environment(\.uploaderDownloader, ImageUploaderDownloader(httpClient: .development))
            .withMessageView()
            .task(id: userId) {
                if userId != nil {
                    await loadUserInfoAndCart()
                }
            }
        }
    }
}


