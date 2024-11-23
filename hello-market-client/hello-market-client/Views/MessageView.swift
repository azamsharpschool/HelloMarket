//
//  MessageView.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/6/24.
//

import SwiftUI

enum MessageType {
    case error
    case info
    case success
}

struct MessageWrapper: Identifiable {
    let id: UUID = UUID()
    var message: String
    var delay: Double = 2.0
    var messageType: MessageType = .error
}

struct MessageView: View {
    
    @Binding var messageWrapper: MessageWrapper?
    
    var backgroundColor: Color {
        
        guard let messageType = messageWrapper?.messageType else {
            return .clear
        }
        
        switch messageType {
        case .error:
            return .red
        case .info:
            return .blue
        case .success:
            return .green
        }
    }
    
    var body: some View {
        
        Text(messageWrapper?.message ?? "")
            .frame(width: 300, alignment: .leading)
            .padding()
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
            .foregroundStyle(.white)
            .task(id: messageWrapper?.id) {
                try? await Task.sleep(for: .seconds(messageWrapper?.delay ?? 2.0))
                guard !Task.isCancelled else { return }
                withAnimation {
                    messageWrapper = nil
                }
            }
    }
}

#Preview {
    Group {
        MessageView(messageWrapper: .constant(MessageWrapper(message: "This is an error message.")))
        
        MessageView(messageWrapper: .constant(MessageWrapper(message: "This is an info message.", messageType: .info)))
        
        MessageView(messageWrapper: .constant(MessageWrapper(message: "Tbis is a success message.", messageType: .success)))

    }
}
