//
//  CartScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import SwiftUI

struct CartScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    
    var body: some View {
        VStack {
            if let cart = cartStore.cart {
                CartItemListView(cartItems: cart.cartItems)
            } else {
                ContentUnavailableView("No items in the cart.", systemImage: "cart")
            }
        }
        .navigationTitle("Cart")
        .task {
            do {
                try await cartStore.loadCart()
            } catch {
                print(error.localizedDescription)
            }
        }
       
    }
}

#Preview {
    NavigationStack {
        CartScreen()
            .environment(CartStore(httpClient: .development))
    }
}
