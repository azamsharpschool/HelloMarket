//
//  WithMessageView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/7/24.
//

import Foundation
import SwiftUI

struct WithMessageView: ViewModifier {
    
    @State private var messageWrapper: MessageWrapper?
    
    func body(content: Content) -> some View {
        content
            .environment(\.showMessage, ShowMessageAction(action: { message, messageType, delay in
                self.messageWrapper = MessageWrapper(message: message, delay: delay, messageType: messageType)
            }))
            .overlay(alignment: .bottom) {
                messageWrapper != nil ? MessageView(messageWrapper: $messageWrapper) : nil
            }
    }
}

extension View {
    
    func withMessageView() -> some View {
        modifier(WithMessageView())
    }
    
}
