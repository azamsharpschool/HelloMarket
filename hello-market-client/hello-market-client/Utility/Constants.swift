//
//  Constants.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import Foundation

struct Constants {
    
    struct Urls {
        
        static let register: URL = URL(string: "http://localhost:8080/api/auth/register")!
        static let login: URL = URL(string: "http://localhost:8080/api/auth/login")!
        static let products: URL = URL(string: "http://localhost:8080/api/products")!
        static let createProduct = URL(string: "http://localhost:8080/api/products")!
        
        static func myProducts(_ userId: Int) -> URL {
            URL(string: "http://localhost:8080/api/products/user/\(userId)")!
        }
        
    }
    
}
