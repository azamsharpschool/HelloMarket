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
                List(cart.cartItems) { cartItem in
                    CartItemView(cartItem: cartItem)
                }
            } else {
                ContentUnavailableView("No items in the cart.", systemImage: "cart")
            }
        }.navigationTitle("Cart")

    }
}

#Preview {
    NavigationStack {
        CartScreen()
            .environment(CartStore(httpClient: .development))
    }
}
