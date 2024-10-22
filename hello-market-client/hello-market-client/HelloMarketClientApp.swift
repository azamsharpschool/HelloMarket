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
    @AppStorage("userId") private var userId: String?
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
            .environment(productStore)
            .environment(\.authenticationController, AuthenticationController(httpClient: .development))
            .environment(\.uploaderDownloader, ImageUploaderDownloader(httpClient: .development))
            .withMessageView()
        }
    }
}


