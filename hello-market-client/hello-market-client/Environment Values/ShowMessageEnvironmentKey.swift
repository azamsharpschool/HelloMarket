//
//  ShowMessageEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/6/24.
//

import Foundation
import SwiftUI

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
