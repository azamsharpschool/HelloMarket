//
//  CartScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import SwiftUI

struct CartScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    
    private func handleQuantityUpdate(productId: Int, quantity: Int) {
        print(quantity)
        Task {
            do {
                try await cartStore.updateItemQuantity(productId: productId, quantity: quantity)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        List {
            if let cart = cartStore.cart {
                HStack {
                    Text("Total: ")
                        .font(.title)
                    Text(cartStore.total, format: .currency(code: "USD"))
                        .font(.title)
                        .bold()
                }
                Button(action: {
                   
                }) {
                    Text("Proceed to checkout ^[(\(cartStore.itemsCount) Item](inflect: true))")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                CartItemListView(cartItems: cart.cartItems, onQuantityUpdate: handleQuantityUpdate)
                
            } else {
                ContentUnavailableView("No items in the cart.", systemImage: "cart")
            }
        }
       
        .listStyle(.plain)
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
