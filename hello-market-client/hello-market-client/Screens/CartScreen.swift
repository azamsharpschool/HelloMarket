//
//  CartScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/2/24.
//

import SwiftUI
import Stripe
import StripePaymentSheet

struct CartScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    @Environment(UserStore.self) private var userStore
    
    @Environment(\.showMessage) private var showMessage
    
    @State private var proceedToCheckout: Bool = false
    @AppStorage("userId") private var userId: Int?
    
    /*
    private func proceedToCheckout() throws {
        
        guard let userId = userId else {
            throw UserError.missingUserId
        }
        
        guard let cart = cartStore.cart else {
            throw CartError.operationFailed("Missing cart")
        }
        
        // convert cart item to order item
        let orderItems = cart.cartItems.map { cartItem in
            OrderItem(product: cartItem.product, quantity: cartItem.quantity)
        }
        
        for item in orderItems {
            print(item.product.name)
        }
    } */
    
    var body: some View {
        List {
            if let cart = cartStore.cart {
                HStack {
                    Text("Total: ")
                        .font(.title)
                    Text(cart.total, format: .currency(code: "USD"))
                        .font(.title)
                        .bold()
                }
                
                Button(action: {
                    proceedToCheckout = true
                }) {
                   
                    Text("Proceed to checkout ^[(\(cart.itemsCount) Item](inflect: true))")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }.buttonStyle(.borderless)
                
                CartItemListView(cartItems: cart.cartItems)
                
            } else {
                ContentUnavailableView("No items in the cart.", systemImage: "cart")
            }
        }
        .navigationDestination(isPresented: $proceedToCheckout, destination: {
            if let cart = cartStore.cart {
                CheckoutScreen(cart: cart)
            }
        })
        .listStyle(.plain)
        .navigationTitle("Cart")
    }
}

#Preview {
    NavigationStack {
        CartScreen()
            .environment(CartStore(httpClient: .development))
            .environment(UserStore(httpClient: .development))
            .environment(\.httpClient, .development)
            .withMessageView()
    }
}
