//
//  OrderConfirmationScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 12/1/24.
//

import SwiftUI

struct OrderConfirmationScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Confirmation Icon
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            // Title
            Text("Order Placed Successfully!")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Description
            Text("Thank you for your purchase! Your order has been successfully placed. We are preparing it for shipment.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
            
            Spacer()
            
        }
        .padding()
        .navigationTitle("Order Confirmation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OrderConfirmationScreen()
    }
}
