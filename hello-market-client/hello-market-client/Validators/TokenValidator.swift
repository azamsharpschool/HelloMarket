//
//  TokenValidator.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/3/24.
//

import Foundation
import JWTDecode

struct TokenValidator {
    
    static func validate(token: String?) -> Bool {
        
        guard let token = token else { return false }
        
        do {
           
            let jwt = try decode(jwt: token)
            
            // Access specific claim - expiration
            if let expirationDate = jwt.expiresAt {
                let currentDate = Date()
                
                // Check if the token has expired
                if currentDate >= expirationDate {
                    return false
                } else {
                    return true
                }
            } else {
                return false // Treat token as invalid if there's no expiration date
            }
        } catch {
            return false // Treat token as invalid if decoding fails
        }
        
    }
    
}
