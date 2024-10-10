//
//  Errors.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/6/24.
//

import Foundation

enum LoginError: LocalizedError {
    case loginFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .loginFailed:
            return NSLocalizedString("Login failed. Please check your username and password.", comment: "Login failure")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .loginFailed:
            return NSLocalizedString("Make sure your credentials are correct and try again.", comment: "Login failure recovery suggestion")
        }
    }
}


enum ProductSaveError: Error {
    case missingUserId
    case invalidPrice
    case operationFailed(String)
}