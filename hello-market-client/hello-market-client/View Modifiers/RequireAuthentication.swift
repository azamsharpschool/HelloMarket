//
//  RequiresAuthentication.swift
//  SmartShop
//
//  Created by Mohammad Azam on 10/9/24.
//

import Foundation
import SwiftUI

struct RequiresAuthentication: ViewModifier {
    
    @State private var isLoading: Bool = true
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                if isAuthenticated {
                    content
                } else {
                    LoginScreen()
                        .withMessageView()
                }
            }
        }.onAppear(perform: checkAuthentication)
    }
    
    private func checkAuthentication() {
        
        guard let token = Keychain<String>.get("jwttoken"), TokenValidator.validate(token: token) else {
            isLoading = false
            isAuthenticated = false
            return
        }
        
        isLoading = false
    }
}

extension View {
    func requiresAuthentication() -> some View {
        modifier(RequiresAuthentication())
    }
}

