//
//  ProductStore.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/11/24.
//

import Foundation
import Observation

@Observable
class ProductStore {
    
    let httpClient: HTTPClient
    private(set) var products: [Product] = []
    private(set) var myProducts: [Product] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadAllProducts() async throws {
        let resource = Resource(url: Constants.Urls.products, modelType: [Product].self)
        products = try await httpClient.load(resource)
    }
    
    func loadMyProducts(by userId: Int) async throws {
        let resource = Resource(url: Constants.Urls.myProducts(userId), modelType: [Product].self)
        myProducts = try await httpClient.load(resource)
    }
    
    func removeProduct(_ product: Product) async throws {
        
        guard let productId = product.id else {
            throw ProductError.missingProductId
        }
        
        let resource = Resource(url: Constants.Urls.deleteProduct(productId), modelType: DeleteProductResponse.self)
    }
    
    func saveProduct(_ product: Product) async throws {
        let resource = Resource(url: Constants.Urls.createProduct, method: .post(product.encode()), modelType: CreateProductResponse.self)
        let response = try await httpClient.load(resource)
        if let product = response.product, response.success {
            myProducts.append(product)
        } else {
            throw ProductError.operationFailed(response.message ?? "")
        }
    }
}
