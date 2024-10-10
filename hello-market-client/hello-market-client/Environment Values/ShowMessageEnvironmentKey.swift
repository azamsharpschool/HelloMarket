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

struct ShowMessageEnvironmentKey: EnvironmentKey {
    static var defaultValue: ShowMessageAction = ShowMessageAction(action: { _, _ in })
}

extension EnvironmentValues {
    var showMessage: (ShowMessageAction) {
        get { self[ShowMessageEnvironmentKey.self] }
        set { self[ShowMessageEnvironmentKey.self] = newValue }
    }
}
