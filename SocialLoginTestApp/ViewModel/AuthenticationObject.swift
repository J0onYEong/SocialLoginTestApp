//
//  CheckingViewViewModel.swift
//  SocialLoginTestApp
//
//  Created by 최준영 on 2023/05/07.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKUser // userApi
import KakaoSDKAuth // authApi

final class AuthenticationObject: ObservableObject {
    
    @Published var presentLoginModal: Bool = false
    
    private var tokenCheckingState: TokenCheckingState = .checking {
        didSet {
            if(tokenCheckingState == .unavailable) {
                presentLoginModal = true
            }
        }
    }
    
    func checkToken() {
        KakaoSocialLogin.shared.checkTokenAvailability { [weak self] result in
            switch(result) {
            case .success(let token):
                GlobalState.shared.setToken(token)
                self?.tokenCheckingState = .available
            case .failure(.tokenUnavailable):
                self?.tokenCheckingState = .unavailable
            }
        }
    }
}
extension AuthenticationObject {
    enum TokenCheckingState {
        case checking, available, unavailable
    }
}
