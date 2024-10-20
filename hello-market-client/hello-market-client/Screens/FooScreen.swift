//
//  FooScreen.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/20/24.
//

import SwiftUI

struct FooScreen: View {
    
    @Environment(\.showMessage) private var showMessage
    
    var body: some View {
        VStack(spacing: 100) {
            Button("Show Success") {
                showMessage("Success", .success)
            }
            Button("Show Failure") {
                showMessage("Failure")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FooScreen()
}
