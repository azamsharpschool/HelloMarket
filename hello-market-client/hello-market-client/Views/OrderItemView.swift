//
//  OrderItemView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 12/2/24.
//

import SwiftUI

struct OrderItemView: View {
    
    let orderItem: OrderItem
    
    private var totalPrice: Double {
        Double(orderItem.quantity) * orderItem.product.price
    }
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: orderItem.product.photoUrl) { img in
                    img.resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView("Loading...")
                }
                Spacer()
                    .frame(width: 20)
                VStack(alignment: .leading) {
                    HStack {
                        Text(orderItem.product.name)
                            .font(.title3)
                        Text("(\(orderItem.quantity))")
                    }
                    Text(totalPrice, format: .currency(code: "USD"))
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    OrderItemView(orderItem: Order.preview.items[0])
}
