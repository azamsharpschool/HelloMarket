//
//  UploaderEnvironmentKey.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/11/24.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var uploaderDownloader = ImageUploaderDownloader(httpClient: HTTPClient())
}
