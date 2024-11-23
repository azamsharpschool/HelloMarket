//
//  CheckoutScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/19/24.
//

import SwiftUI

struct CheckoutScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    @Environment(UserStore.self) private var userStore
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if let cart = cartStore.cart {
                
                Text("By placing your order, you agree to SmartShop privacy notice and conditions of use.")
                    .font(.caption)
                
                Button(action: {
                   
                }) {
                   
                    Text("Place your order")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                        .padding()
                }.buttonStyle(.borderless)
                
                VStack(spacing: 10) {
                    Text("Place your order")
                        .font(.title3)
                       
                    HStack {
                        Text("Items:")
                        Spacer()
                        Text(cartStore.total, format: .currency(code: "USD"))
                    }
                    
                    HStack {
                        Text("Shipping and handling:")
                        Spacer()
                        Text(0.00, format: .currency(code: "USD"))
                    }
                    
                    HStack {
                        Text("Estimated tax to be collected:")
                        Spacer()
                        Text(0.00, format: .currency(code: "USD"))
                    }
                    
                    if let userInfo = userStore.userInfo, let _ = userInfo.firstName {
                        
                        Text("Delivering to \(userInfo.fullName)")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(userInfo.address)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    } else {
                       Text("Please update your profile and add the missing information.")
                            .foregroundStyle(.red)
                    }
                    
                }
                .padding()
                
                CartItemListView(cartItems: cart.cartItems)
                    .padding()
            }
            Spacer()
        }
      
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        })
        .navigationTitle("Place Your Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CheckoutScreen()
            .withMessageView()
    }
    .environment(CartStore(httpClient: .development))
    .environment(UserStore(httpClient: .development))
    
}
