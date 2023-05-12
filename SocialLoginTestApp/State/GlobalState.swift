//
//  GlobalState.swift
//  SocialLoginTestApp
//
//  Created by 최준영 on 2023/05/13.
//

import Foundation
import KakaoSDKAuth

class GlobalState {
    private init() {}
    
    static var shared = GlobalState()
    
    private(set) var tokenIsAvailable = false
    
    private(set) var token: OAuthToken?
    
    
    func setToken(_ token: OAuthToken) {
        self.token = token
        tokenIsAvailable = true
    }
    
    func deleteToken() {
        self.token = nil
        tokenIsAvailable = false
    }
    
}
