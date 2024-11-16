//
//  CartItemView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import SwiftUI

struct CartItemView: View {
    
    let cartItem: CartItem
    @State private var quantity: Int = 0
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: cartItem.product.photoUrl) { img in
                    img.resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView("Loading...")
                }
                Spacer()
                    .frame(width: 20)
                VStack(alignment: .leading) {
                    Text(cartItem.product.name)
                        .font(.title3)
                    Text(cartItem.product.price, format: .currency(code: "USD"))
                    
                    CartItemQuantityView(cartItem: cartItem)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
        }.onAppear {
            quantity = cartItem.quantity
        }
    }
}

#Preview {
    CartItemView(cartItem: CartItem.preview)
        .environment(CartStore(httpClient: .development))
}
