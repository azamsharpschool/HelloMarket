//
//  AuthenticationController.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 9/5/24.
//

import Foundation

struct AuthenticationController {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func register(username: String, password: String) async throws -> RegisterResponse {
        
        let body = ["username": username, "password": password]
        let bodyData = try JSONEncoder().encode(body)
        
        // make the request
        let resource = Resource(url: Constants.Urls.register, method: .post(bodyData), modelType: RegisterResponse.self)
        let response = try await httpClient.load(resource)
        
        return response
    }
    
    func login(username: String, password: String) async throws  {
        
        let body = ["username": username, "password": password]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.login, method: .post(bodyData), modelType: LoginResponse.self)
        let response = try await httpClient.load(resource)
        
        if let token = response.token, response.success {
            // save the token in the Keychain
            Keychain.set(token, forKey: "jwttoken")
        } else {
            throw LoginError.loginFailed(response.message ?? "Unable to login.")
        }
    }
}

extension AuthenticationController {
    
    static var development: AuthenticationController {
        AuthenticationController(httpClient: HTTPClient())
    }
    
}
