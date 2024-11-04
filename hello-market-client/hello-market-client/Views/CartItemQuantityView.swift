//
//  CartItemQuantityView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/3/24.
//

import SwiftUI

enum QuantityChangeType: Equatable {
    case update(Int)
    case delete
}

struct CartItemQuantityView: View {
    
    @Environment(CartStore.self) private var cartStore
    let cartItem: CartItem
    @State private var quantity: Int = 0
    @State private var quantityChangeType: QuantityChangeType?
    
    var body: some View {
        HStack {
            Button {
                if quantity == 1 {
                    quantityChangeType = .delete
                } else {
                   
                    quantity -= 1
                    quantityChangeType = .update(-1)
                }
            } label: {
                Image(systemName: cartItem.quantity == 1 ? "trash" : "minus")
                    .frame(width: 24, height: 24) // Set a fixed frame size
            }
            Text("\(cartItem.quantity)")
            
            Button(action: {
                quantity += 1
                quantityChangeType = .update(1)
            }) {
                Image(systemName: "plus")
            }
        }
        .task(id: quantityChangeType) {
            if let quantityChangeType {
                print("quantityChangeType")
                switch quantityChangeType {
                    case .update(let quantity):
                        do {
                            try await cartStore.updateItemQuantity(productId: cartItem.product.id!, quantity: quantity)
                        } catch {
                            // Handle the error here, e.g., show a message or log it
                            print("Failed to update item quantity: \(error)")
                        }
                    case .delete:
                        do {
                            try await cartStore.deleteCartItem(cartItemId: cartItem.id!)
                        } catch {
                            // Handle the error here, e.g., show a message or log it
                            print("Failed to delete cart item: \(error)")
                        }
                }
                
                self.quantityChangeType = nil
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
