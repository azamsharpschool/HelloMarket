//
//  ProductDetailScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/13/24.
//

import SwiftUI

struct ProductDetailScreen: View {
    
    let product: Product
    @Environment(CartStore.self) private var cartStore
    
    @State private var quantity: Int = 1
    
    private func addToCart() async throws {
        
        guard let productId = product.id else {
            throw ProductError.productNotFound  
        }
        
        try await cartStore.addItemToCart(productId: productId, quantity: quantity)
    }
    
    var body: some View {
        ScrollView {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .scaledToFit()
            } placeholder: {
                ProgressView("Loading...")
            }
            
            Text(product.name)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(product.description)
                .padding([.top], 5)
            Text(product.price, format: .currency(code: "USD"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding([.top], 2)
            
            Stepper(value: $quantity) {
                Text("Quantity: \(quantity)")
            }
            
            Button {
                Task {
                    do {
                        try await addToCart()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                } label: {
                    Text("Add to cart")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(25)
                }
               
            
        }.padding()
    }
}

#Preview {
    ProductDetailScreen(product: Product.preview)
        .environment(CartStore(httpClient: .development))
        .withMessageView()
}
