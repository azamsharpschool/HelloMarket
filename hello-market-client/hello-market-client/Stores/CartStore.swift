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
    
    var lastError: Error?
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    /*
    var total: Double {
        cart?.cartItems.reduce(0.0, { total, cartItem in
            total + (cartItem.product.price * Double(cartItem.quantity))
        }) ?? 0.0
    } */
    
    /*
    var itemsCount: Int {
        cart?.cartItems.reduce(0) { total, item in
            total + item.quantity
        } ?? 0
    } */
    
    func emptyCart() {
        cart = nil
    }
    
    func loadCart() async {
        
        let resource = Resource(url: Constants.Urls.loadCart, modelType: CartResponse.self)
        do {
            let response = try await httpClient.load(resource)
            
            if let cart = response.cart, response.success {
                self.cart = cart
            }
        } catch {
            lastError = error 
        }
    }
    
    func deleteCartItem(cartItemId: Int) async throws {
        
        let resource = Resource(url: Constants.Urls.deleteCartItem(cartItemId), method: .delete, modelType: DeleteCartItemResponse.self)
        
        let response = try await httpClient.load(resource)
        
        if response.success {
            // remove the cartItem from cartItems
            if let cart = cart {
                self.cart?.cartItems = cart.cartItems.filter { $0.id != cartItemId }
            }
        } else {
            throw CartError.operationFailed(response.message ?? "")
        }
    }
    
    func updateItemQuantity(productId: Int, quantity: Int) async throws {
        
        try await addItemToCart(productId: productId, quantity: quantity)
    }
    
    func addItemToCart(productId: Int, quantity: Int) async throws {
        
        let body = ["product_id": productId, "quantity": quantity]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.addCartItem, method: .post(bodyData), modelType: CartItemResponse.self)
        let response = try await httpClient.load(resource)
        
        if let cartItem = response.cartItem, response.success {
            // Initialize cart if it's nil
            if cart == nil {
                guard let userId = UserDefaults.standard.userId else { throw UserError.missingUserId }
                cart = Cart(userId: userId)
            }
            
            // if item already exists then update it else insert it
            if let index = cart?.cartItems.firstIndex(where: { $0.id == cartItem.id }) {
                cart?.cartItems[index] = cartItem
            } else {
                // new item
                cart?.cartItems.append(cartItem)
            }
        } else {
            throw CartError.operationFailed(response.message ?? "")
        }
    }

}
