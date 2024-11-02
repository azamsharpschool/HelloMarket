//
//  CartView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import SwiftUI

struct CartView: View {
    
    let cartItems: [CartItem]
    
    var body: some View {
        List(cartItems) { cartItem in
            CartItemView(cartItem: cartItem)
        }.listStyle(.plain)
    }
}

#Preview {
    CartView(cartItems: Cart.preview.cartItems)
}
