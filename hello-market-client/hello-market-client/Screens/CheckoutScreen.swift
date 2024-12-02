//
//  CheckoutScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/19/24.
//

import SwiftUI
import Stripe
import StripePaymentSheet

struct CheckoutScreen: View {
    
    let order: Order
    
    @Environment(\.paymentController) private var paymentController
    
    @Environment(UserStore.self) private var userStore
    @Environment(OrderStore.self) private var orderStore
    @Environment(CartStore.self) private var cartStore
    
    @State private var paymentSheet: PaymentSheet?
    @State private var presentOrderConfirmationScreen: Bool = false
    
    @Environment(\.dismiss) private var dismiss
  
    private func paymentCompletion(result: PaymentSheetResult) {

        switch result {
            case .completed:
                Task {
                    do {
                        try await orderStore.saveOrder(order: order)
                        cartStore.emptyCart()
                        presentOrderConfirmationScreen = true
                    } catch {
                        print(error)
                    }
                }
            case .canceled:
                print("canceled")
            case .failed(let error):
                print(error.localizedDescription)
        }
        
    }
    
    var body: some View {
        List {
                
                VStack(spacing: 10) {
                    Text("Place your order")
                        .font(.title3)
                       
                    HStack {
                        Text("Items:")
                        Spacer()
                        Text(order.total, format: .currency(code: "USD"))
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
                
                ForEach(order.items, id: \.product.id) { orderItem in
                    OrderItemView(orderItem: orderItem)
                }
                
                // payment sheet button
                if let paymentSheet = paymentSheet {
                    PaymentSheet.PaymentButton(
                        paymentSheet: paymentSheet,
                        onCompletion: paymentCompletion
                    ) {
                        Text("Place your order")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                                .padding()
                                .buttonStyle(.borderless)
                    }
                }
            
            Spacer()
        }
        .navigationDestination(isPresented: $presentOrderConfirmationScreen, destination: {
            OrderConfirmationScreen()
                .navigationBarBackButtonHidden()
        })
        .task {
            do {
                paymentSheet = try await paymentController.preparePaymentSheet(for: order)
            } catch {
                print(error)
            }
        }
        
        .listStyle(.plain)
      
        .navigationTitle("Place Your Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CheckoutScreen(order: Order.preview)
            .withMessageView()
    }
    .environment(CartStore(httpClient: .development))
    .environment(UserStore(httpClient: .development))
    .environment(OrderStore(httpClient: .development))
    .environment(\.httpClient, .development)
    
    
}
