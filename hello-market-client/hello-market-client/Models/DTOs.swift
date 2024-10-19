//
//  RegisterResponse.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import Foundation

struct RegisterResponse: Codable {
    let message: String?
    let success: Bool 
}

struct LoginResponse: Codable {
    let message: String?
    let token: String?
    let success: Bool 
    let userId: Int?
    let username: String?
}

struct ErrorResponse: Codable {
    let message: String?
}

struct UploadDataResponse: Codable {
    let message: String?
    let success: Bool
    let downloadURL: URL? 
}

struct Product: Codable, Identifiable {
    
    var id: Int?
    let name: String
    let description: String
    let price: Double
    let photoUrl: URL?
    let userId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case photoUrl = "photo_url"
        case userId = "user_id"
    }
}

extension Product {
    
    static var preview: Product {
        Product(id: 1, name: "Mirra Chair", description: "The Mirra chair by Herman Miller is an ergonomic office chair designed for comfort and support. It features an adjustable backrest, seat, and armrests, along with a flexible back that adapts to body movements. The chair's breathable mesh promotes airflow, while its responsive design encourages proper posture, making it ideal for long periods of sitting.", price: 850, photoUrl: URL(string: "http://localhost:8080/images/chair.jpg")!, userId: 1)
    }
    
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
}

struct CreateProductResponse: Codable {
    let success: Bool
    let product: Product?
    let message: String? 
}

struct DeleteProductResponse: Codable {
    let success: Bool
    let message: String? 
}

