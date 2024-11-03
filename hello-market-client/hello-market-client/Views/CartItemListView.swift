//
//  CartView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import SwiftUI

struct CartItemListView: View {
    
    let cartItems: [CartItem]
    let onQuantityUpdate: (Int, Int) -> Void
    
    var body: some View {
        ForEach(cartItems) { cartItem in
            CartItemView(cartItem: cartItem, onQuantityUpdate: onQuantityUpdate)
        }.listStyle(.plain)
    }
}

#Preview {
    CartItemListView(cartItems: Cart.preview.cartItems, onQuantityUpdate: { _, _  in })
}
