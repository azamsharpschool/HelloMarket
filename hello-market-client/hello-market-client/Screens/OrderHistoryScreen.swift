//
//  OrderHistoryScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 12/2/24.
//

import SwiftUI

struct OrderHistoryScreen: View {
    
    @Environment(OrderStore.self) private var orderStore
    
    var body: some View {
        List(orderStore.orders) { order in
            VStack(alignment: .leading) {
                Text("Order ID: \(order.id!)")
                    .font(.title)
                Text(order.total, format: .currency(code: "USD"))
                    .bold()
                ForEach(order.items) { orderItem in
                    OrderItemView(orderItem: orderItem)
                }
            }
        }
        .navigationTitle("Order History")
        .listStyle(.plain)
        .task {
            do {
                try await orderStore.loadOrders()
            } catch {
                print(error.localizedDescription)
            } 
        }
    }
}

#Preview {
    NavigationStack {
        OrderHistoryScreen()
            .environment(OrderStore(httpClient: .development))
    }
}
