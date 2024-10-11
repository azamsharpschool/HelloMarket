//
//  UploaderEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/11/24.
//

import Foundation
import SwiftUI

private struct UploaderEnvironmentKey: EnvironmentKey {
  static let defaultValue = Uploader(httpClient: HTTPClient())
}

extension EnvironmentValues {
  var uploader: Uploader {
    get { self[UploaderEnvironmentKey.self] }
    set { self[UploaderEnvironmentKey.self] = newValue }
  }
}
