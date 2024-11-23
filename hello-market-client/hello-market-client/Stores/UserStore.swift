//
//  UserStore.swift
//  hello-market-client
//
//  Created by Mohammad Azam on 11/23/24.
//

import Foundation
import Observation

@MainActor
@Observable
class UserStore {
    
    var userInfo: UserInfo?
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadUserInfo() async throws {
        
        let resource = Resource(url: Constants.Urls.loadUserInfo, modelType: UserInfoResponse.self)
        let response = try await httpClient.load(resource)
        
        if let userInfo = response.userInfo, response.success {
            self.userInfo = userInfo
        } else {
            throw UserError.operationFailed(response.message ?? "")
        }
    }
    
    func updateUserInfo(userInfo: UserInfo) async throws {
        
        let userInfoData = try JSONEncoder().encode(userInfo)
        
        let resource = Resource(url: Constants.Urls.updateUserInfo, method: .put(userInfoData), modelType: UserInfoResponse.self)
        
        let response = try await httpClient.load(resource)
        
        if let userInfo = response.userInfo, response.success {
            self.userInfo = userInfo
        } else {
            throw UserError.operationFailed(response.message ?? "")
        }
        
    }
}
