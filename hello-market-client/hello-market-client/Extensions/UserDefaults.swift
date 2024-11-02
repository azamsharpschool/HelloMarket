//
//  UserDefaults.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let userId = "userId"
    }
    
    var userId: Int? {
        get {
            let id = integer(forKey: Keys.userId)
            return id == 0 ? nil : id // Return nil if userId hasn't been set
        }
        set {
            set(newValue, forKey: Keys.userId)
        }
    }
}
