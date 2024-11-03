//
//  CartStore.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import Foundation
import Observation

@MainActor
@Observable
class CartStore {
    
    let httpClient: HTTPClient
    var cart: Cart?
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    var total: Double {
        cart?.cartItems.reduce(0.0, { total, cartItem in
            total + (cartItem.product.price * Double(cartItem.quantity))
        }) ?? 0.0
    }
    
    var itemsCount: Int {
        cart?.cartItems.reduce(0) { total, item in
            total + item.quantity
        } ?? 0
    }
    
    func loadCart() async throws {
        
        let resource = Resource(url: Constants.Urls.loadCart, modelType: CartResponse.self)
        let response = try await httpClient.load(resource)
        
        if let cart = response.cart, response.success {
            self.cart = cart
            print(cart.cartItems)
        } else {
            throw CartError.operationFailed(response.message ?? "")
        }
    }
    
    func updateItemQuantity(productId: Int, quantity: Int) async throws {
        
        // if quantity is zero then delete it
        
        // if quantity is > zero then add to the cart, which will update the cart
        
        try await addItemToCart(productId: productId, quantity: quantity)
    }
    
    func addItemToCart(productId: Int, quantity: Int) async throws {
        
        guard quantity > 0 else {
            throw CartError.invalidQuantity
        }
        
        let body = ["product_id": productId, "quantity": quantity]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.addCartItem, method: .post(bodyData), modelType: CartItemResponse.self)
        let response = try await httpClient.load(resource)
        
        if let cartItem = response.cartItem, response.success {
            // if item already exists then update it else insert it
            let index = cart?.cartItems.firstIndex(where: { $0.id == cartItem.id })
            if let index {
                cart?.cartItems[index] = cartItem
            } else {
                
                guard let userId = UserDefaults.standard.userId else { throw UserError.missingUserId }
                
                // initialze the cart
                cart = Cart(userId: userId)
                // new item
                cart?.cartItems.append(cartItem)
            }
        } else {
            throw CartError.operationFailed(response.message ?? "")
        }
        
    }
    
}
