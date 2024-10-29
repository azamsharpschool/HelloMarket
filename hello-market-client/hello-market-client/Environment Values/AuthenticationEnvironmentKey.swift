//
//  AuthenticationEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
}
