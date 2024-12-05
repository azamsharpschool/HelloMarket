//
//  PaymentService.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 12/1/24.
//

import Foundation
import Stripe
import StripePaymentSheet

struct PaymentController {
    
    private let httpClient: HTTPClient // Inject the HTTP client for API calls

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    @MainActor
    func preparePaymentSheet(for cart: Cart) async throws -> PaymentSheet {
       
        let params = ["totalAmount": cart.total]
        let paramsData = try JSONEncoder().encode(params)
        
        let resource = Resource(
            url: Constants.Urls.createPaymentIntent,
            method: .post(paramsData),
            modelType: CreatePaymentIntentResponse.self
        )
        
        let response = try await httpClient.load(resource)

        guard let customerId = response.customerId,
              let customerEphemeralKeySecret = response.customerEphemeralKeySecret,
              let paymentIntentClientSecret = response.paymentIntentClientSecret
        else {
            throw PaymentServiceError.missingPaymentDetails
        }

        STPAPIClient.shared.publishableKey = response.publishableKey
        
        // Create PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "HelloMarket, Inc."
        configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)

        return PaymentSheet(
            paymentIntentClientSecret: paymentIntentClientSecret,
            configuration: configuration
        )
    }

   
}

// MARK: - Custom Error Types
enum PaymentServiceError: Error {
    case missingPaymentDetails
}
