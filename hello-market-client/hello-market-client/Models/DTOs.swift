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

struct Product: Codable, Identifiable, Hashable {
    
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

struct UpdateProductResponse: Codable {
    let success: Bool
    let message: String?
    let product: Product?
}

// Cart
struct Cart: Codable, Identifiable {
    var id: Int?
    let userId: Int
    var cartItems: [CartItem] = []
    
    private enum CodingKeys: String, CodingKey {
        case id, cartItems
        case userId = "user_id"
    }
}

extension Cart {
    
    var total: Double {
        cartItems.reduce(0.0, { total, cartItem in
            total + (cartItem.product.price * Double(cartItem.quantity))
        })
    }
    
    var itemsCount: Int {
        cartItems.reduce(0) { total, item in
            total + item.quantity
        } 
    }
}

extension Cart {
    static var preview: Cart {
        return Cart(
            id: 1,
            userId: 101,
            cartItems: [
                CartItem(
                    id: 1,
                    product: Product(
                        id: 201,
                        name: "Coffee",
                        description: "A rich, aromatic blend of premium coffee beans.",
                        price: 5.99,
                        photoUrl: URL(string: "https://picsum.photos/200/300"),
                        userId: 101
                    ),
                    quantity: 2
                ),
                CartItem(
                    id: 2,
                    product: Product(
                        id: 202,
                        name: "Tea",
                        description: "Refreshing green tea with hints of mint.",
                        price: 3.49,
                        photoUrl: URL(string: "https://picsum.photos/200/300"),
                        userId: 101
                    ),
                    quantity: 1
                ),
                CartItem(
                    id: 3,
                    product: Product(
                        id: 203,
                        name: "Hot Chocolate",
                        description: "Smooth and creamy hot chocolate.",
                        price: 4.99,
                        photoUrl: URL(string: "https://picsum.photos/200/300"),
                        userId: 101
                    ),
                    quantity: 3
                )
            ]
        )
    }
}


struct CartItem: Codable, Identifiable, Hashable {
    let id: Int?
    let product: Product
    var quantity: Int = 1
}

extension CartItem {
    
    static var preview: CartItem {
        CartItem(id: 1, product: Product.preview, quantity: 2)
    }
}

struct CartItemResponse: Codable {
    let success: Bool
    let message: String?
    let cartItem: CartItem?
}

struct CartResponse: Codable {
    let success: Bool
    let message: String?
    let cart: Cart?
}

struct DeleteCartItemResponse: Codable {
    let success: Bool
    let message: String?
}

struct UserInfo: Codable, Equatable {
    let firstName: String?
    let lastName: String?
    let street: String?
    let city: String?
    let state: String?
    let zipCode: String?
    let country: String?
    
    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case zipCode = "zip_code"
        case street, city, state, country
    }
    
    var address: String {
        [
            street,
            [city, state].compactMap { $0 }.joined(separator: " "),
            zipCode,
            country
        ]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
    
    var fullName: String {
        [firstName, lastName]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

struct UserInfoResponse: Codable {
    let success: Bool
    let message: String?
    let userInfo: UserInfo?
}

struct CreatePaymentIntentResponse: Codable {
    let paymentIntentClientSecret: String?
    let customerId: String?
    let customerEphemeralKeySecret: String?
    let publishableKey: String?
    
    private enum CodingKeys: String, CodingKey {
        case publishableKey
        case paymentIntentClientSecret = "paymentIntent"
        case customerId = "customer"
        case customerEphemeralKeySecret = "ephemeralKey"
        
    }
}

struct OrderItem: Codable, Hashable, Identifiable {
    var id: Int?
    let product: Product
    var quantity: Int = 1
    
    init(from cartItem: CartItem) {
        self.id = nil
        self.product = cartItem.product
        self.quantity = cartItem.quantity
    }
}

struct Order: Codable, Hashable, Identifiable {
    var id: Int?
    let userId: Int
    var total: Double
    var items: [OrderItem]
    
    init(from cart: Cart) {
        self.id = nil
        self.userId = cart.userId
        self.total = cart.total
        self.items = cart.cartItems.map(OrderItem.init)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, total, items
        case userId = "user_id"
    }
    
    func toRequestBody() -> [String: Any] {
        return [
            "user_id": userId,
            "total": total,
            "order_items": items.map { item in
                [
                    "product_id": item.product.id,
                    "quantity": item.quantity
                ]
            }
        ]
    }
}

extension Order {
    static var preview: Order {
        
        Order(from: Cart.preview)
        
        /*
        Order(id: 1, userId: 2, total: 10, items: Cart.preview.cartItems.map({ cartItem in
            OrderItem(id: cartItem.id, product: cartItem.product, quantity: cartItem.quantity)
        })) */
    }
}



struct SaveOrderResponse: Codable {
    let success: Bool
    let message: String?
}




