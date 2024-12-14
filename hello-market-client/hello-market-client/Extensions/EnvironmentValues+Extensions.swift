//
//  EnvironmentValues+Extensions.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 12/14/24.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var paymentController = PaymentController(httpClient: HTTPClient())
}

extension EnvironmentValues {
    @Entry var httpClient = HTTPClient()
}

extension EnvironmentValues {
    @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
}

struct ShowMessageAction {
    typealias Action = (String, MessageType, Double) -> ()
    let action: Action

    func callAsFunction(_ message: String, _ messageType: MessageType = .error, delay: Double = 2.0) {
        action(message, messageType, delay)
    }
}

extension EnvironmentValues {
    @Entry var showMessage: ShowMessageAction = ShowMessageAction { _, _, _ in }
}

extension EnvironmentValues {
    @Entry var uploaderDownloader = ImageUploaderDownloader(httpClient: HTTPClient())
}


