//
//  Uploader.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 10/11/24.
//

import Foundation

enum MimeType: String {
    case jpg = "image/jpg"
    case png = "image/png"
    case gif = "image/gif"
    case bmp = "image/bmp"
    case tiff = "image/tiff"
    case pdf = "application/pdf"
    case json = "application/json"
    case html = "text/html"
    case plainText = "text/plain"
    
    var value: String {
        return self.rawValue
    }
}

struct ImageUploaderDownloader {
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func upload(data: Data, mimeType: MimeType = .png) async throws -> URL? {
        
        let boundary = UUID().uuidString
        let headers = ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
        
        let body = createMultipartFormDataBody(data: data, boundary: boundary)
        let resource = Resource(url: Constants.Urls.uploadProductImage, method: .post(body), headers: headers, modelType: UploadDataResponse.self)
        
        let response = try await httpClient.load(resource)
        return response.downloadURL
    }
    
    func download(from url: URL) async throws -> Data? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    private func createMultipartFormDataBody(data: Data, mimeType: MimeType = .png, boundary: String) -> Data {
        var body = Data()
        
        let lineBreak = "\r\n"

        // Add the file data
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        
        // Specify the Content-Disposition with name and filename
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"upload.png\"\(lineBreak)".data(using: .utf8)!)
        
        // Specify the Content-Type of the file
        body.append("Content-Type: \(mimeType.value)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        
        // Add the actual file data
        body.append(data)
        body.append(lineBreak.data(using: .utf8)!)
        
        // Add the closing boundary
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }

    
}
