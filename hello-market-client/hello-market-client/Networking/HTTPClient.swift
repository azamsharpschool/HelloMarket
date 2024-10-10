//
//  HTTPClient.swift
//  GroceryApp
//
//  Created by Mohammad Azam on 5/7/23.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError(Error)
    case invalidResponse
    case errorResponse(ErrorResponse)
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
            case .badRequest:
                return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "badRequestError")
            case .decodingError(let error):
                return NSLocalizedString("Unable to decode successfully. \(error)", comment: "decodingError")
            case .invalidResponse:
                return NSLocalizedString("Invalid response.", comment: "invalidResponse")
            case .errorResponse(let errorResponse):
                return NSLocalizedString("Error \(errorResponse.message ?? "")", comment: "Error Response")
        }
    }
}

enum HTTPMethod {
    case get([URLQueryItem])
    case post(Data?)
    case delete
    case put(Data?)
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var method: HTTPMethod = .get([])
    var headers: [String: String]? = nil
    var modelType: T.Type
}


struct HTTPClient {
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        
        var request = URLRequest(url: resource.url)
        
        // Set HTTP method and body if needed
        switch resource.method {
            case .get(let queryItems):
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
                guard let url = components?.url else {
                    throw NetworkError.badRequest
                }
                request.url = url
                
            case .post(let data), .put(let data):
                request.httpMethod = resource.method.name
                request.httpBody = data
                
            case .delete:
                request.httpMethod = resource.method.name
        }
        
        // Set custom headers
        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Check for specific HTTP errors
        switch httpResponse.statusCode {
            case 200...299:
                break // Success
            default:
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkError.errorResponse(errorResponse)
        }
        
        do {
            let result = try JSONDecoder().decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

extension HTTPClient {
    
    static var development: HTTPClient {
        HTTPClient()
    }
    
}

