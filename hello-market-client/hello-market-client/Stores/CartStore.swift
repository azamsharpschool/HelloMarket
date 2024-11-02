//
//  CartStore.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import Foundation
import Observation

@Observable
class CartStore {
    
    let httpClient: HTTPClient
    
    var cart: Cart?
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func addItemToCart(productId: Int, quantity: Int) async throws {
        
        let body = ["product_id": productId, "quantity": quantity]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.addCartItem, method: .post(bodyData), modelType: CartItem.self)
        
    }
    
}
