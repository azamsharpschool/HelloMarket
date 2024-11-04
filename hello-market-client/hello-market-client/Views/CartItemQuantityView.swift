//
//  CartItemQuantityView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/3/24.
//

import SwiftUI

struct CartItemQuantityView: View {
    
    @Environment(CartStore.self) private var cartStore
    let cartItem: CartItem
    @State private var quantity: Int = 0
    
    private func deleteCartItem() async {
        do {
            try await cartStore.deleteCartItem(cartItemId: cartItem.id!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateItemQuantity() async {
        do {
            try await cartStore.updateItemQuantity(productId: cartItem.product.id!, quantity: quantity)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        HStack {
            Button {
                if quantity == 1 {
                    Task { await deleteCartItem() }
                } else {
                    quantity -= 1
                    Task { await updateItemQuantity() }
                }
            } label: {
                Image(systemName: quantity == 1 ? "trash" : "minus")
                    .frame(width: 24, height: 24) // Set a fixed frame size
            }
            Text("\(quantity)")
            
            Button(action: {
                quantity += 1
                Task { await updateItemQuantity() }
            }) {
                Image(systemName: "plus")
            }
        }
        .onAppear(perform: {
            quantity = cartItem.quantity
        })
        .frame(width: 150)
        .background(.gray)
        .foregroundStyle(.white)
        .buttonStyle(.borderedProminent)
        .tint(.gray)
        .cornerRadius(15.0)
    }
}

#Preview {
    CartItemQuantityView(cartItem: CartItem.preview)
        .environment(CartStore(httpClient: .development))
}
