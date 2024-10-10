//
//  AuthenticationEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import Foundation
import SwiftUI

private struct AuthenticationEnvironmentKey: EnvironmentKey {
  static let defaultValue = AuthenticationController(httpClient: HTTPClient())
}

extension EnvironmentValues {
  var authenticationController: AuthenticationController {
    get { self[AuthenticationEnvironmentKey.self] }
    set { self[AuthenticationEnvironmentKey.self] = newValue }
  }
}
