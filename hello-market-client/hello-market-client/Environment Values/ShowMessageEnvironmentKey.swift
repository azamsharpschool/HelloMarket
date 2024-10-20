//
//  ShowMessageEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/6/24.
//

import Foundation
import SwiftUI

struct ShowMessageAction {
    typealias Action = (String, MessageType) -> ()
    let action: Action

    func callAsFunction(_ message: String, _ messageType: MessageType = .error) {
        action(message, messageType)
    }
}

extension EnvironmentValues {
    @Entry var showMessage: ShowMessageAction = ShowMessageAction { _, _ in }
}
