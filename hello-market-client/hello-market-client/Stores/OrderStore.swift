//
//  OrderStore.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 12/1/24.
//

import Foundation
import Observation

@MainActor
@Observable
class OrderStore {
    
    var httpClient: HTTPClient
    var orders: [Order] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadOrders() async throws {
        let resource = Resource(url: Constants.Urls.loadOrders, modelType: [Order].self)
        orders = try await httpClient.load(resource)
    }
    
    func saveOrder(order: Order) async throws {
        
        let body = try! JSONSerialization.data(withJSONObject: order.toRequestBody(), options: [])
       
        let resource = Resource(url: Constants.Urls.saveOrder, method: .post(body), modelType: SaveOrderResponse.self)
        let response = try await httpClient.load(resource)
        
        if !response.success {
            throw OrderError.saveFailed(response.message ?? "Unable to save product. Please try again.")
        }
    }
    
}
