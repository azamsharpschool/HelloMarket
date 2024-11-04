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
    let onQuantityUpdate: (Int, Int) -> Void
    let onCartItemDelete: (Int) -> Void
    
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
                    
                    /*
                    HStack {
                        Button {
                            if quantity == 1 {
                                print("about to delete")
                                onCartItemDelete(cartItem.id!)
                            } else {
                                quantity -= 1
                                onQuantityUpdate(cartItem.product.id!, quantity)
                            }
                        } label: {
                            Image(systemName: quantity == 1 ? "trash" : "minus")
                                .frame(width: 24, height: 24) // Set a fixed frame size
                        }
                        Text("\(quantity)")
                      
                        Button(action: {
                                quantity += 1
                                onQuantityUpdate(cartItem.product.id!, quantity)
                            }) {
                                Image(systemName: "plus")
                            }
                    }
                    .frame(width: 120)
                    .background(.gray)
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                    .cornerRadius(15.0)
                    */
                    
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
        }.onAppear {
            quantity = cartItem.quantity
        }
    }
}

#Preview {
    CartItemView(cartItem: CartItem.preview, onQuantityUpdate: { _, _  in }, onCartItemDelete: { _ in })
        .environment(CartStore(httpClient: .development))
}
