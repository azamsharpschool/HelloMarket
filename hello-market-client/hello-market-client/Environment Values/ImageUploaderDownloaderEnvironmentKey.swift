//
//  UploaderEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/11/24.
//

import Foundation
import SwiftUI

private struct ImageUploaderDownloaderEnvironmentKey: EnvironmentKey {
  static let defaultValue = ImageUploaderDownloader(httpClient: HTTPClient())
}

extension EnvironmentValues {
  var uploaderDownloader: ImageUploaderDownloader {
    get { self[ImageUploaderDownloaderEnvironmentKey.self] }
    set { self[ImageUploaderDownloaderEnvironmentKey.self] = newValue }
  }
}
