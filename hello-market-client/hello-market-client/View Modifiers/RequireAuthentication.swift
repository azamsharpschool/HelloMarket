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
    @AppStorage("userId") private var userId: String?
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                if userId != nil {
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
            userId = nil
            isLoading = false
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

