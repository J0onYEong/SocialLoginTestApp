//
//  SocialLoginViewModel.swift
//  SocialLoginTestApp
//
//  Created by 최준영 on 2023/05/06.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKUser // userApi
import KakaoSDKAuth // authApi

class SocialLoginViewModel: ObservableObject {
    
    @Published var tokenCheckingState: TokenCheckingState = .checking
    
    
    // MARK: - (Kakao)토큰유효성 검사
    func checkTokenAvailability() {
        if (AuthApi.hasToken()) {
            //토큰이 존재함으로 유효성 검사실행
            UserApi.shared.accessTokenInfo { [self] (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //토큰이 유효하지 않음, 로그인 필요
                        self.tokenCheckingState = .unavailable
                    }
                    else {
                        //기타 에러
                        self.tokenCheckingState = .unavailable
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.tokenCheckingState = .available
                }
            }
        } else {
            //토큰없음
            tokenCheckingState = .unavailable
        }
    }
    
    // 토큰만 가지고 있으면 얻을 수 있다.
    func getUserInfo() {
        if (AuthApi.hasToken()) {
            UserApi.shared.me { user, error in
                if let error = error {
                    print(error)
                    return;
                }
                
                if let user = user {
                    print(user.kakaoAccount?.email)
                }
            }
        } else {
            // 토큰이 없음으로 로그인이 필요함
            print("토큰이 존재하지 않음")
        }
    }
    
    // MARK: - (Kakao)Login
    func kakaoSocialLogin() {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //토큰이 유효하지 않음, 로그인 필요
                        self.loginRequest()
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                }
            }
        }
        else {
            //토큰이 존재하지 않음, 로그인 필요
            self.loginRequest()
        }
    }
    
    private func loginRequest() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 요청
            UserApi.shared.loginWithKakaoTalk(completion: loginCallback)
        } else {
            // 브라우저를 통해 로그인
            UserApi.shared.loginWithKakaoAccount(completion: loginCallback)
        }
    }
    
    private func loginCallback(_ oathToken: OAuthToken?, _ error: Error?) {
        if let error = error {
            print("소셜 로그인 실패", error, separator: "\n")
        } else {
            // 로그인 성공
            print("소셜 로그인 성공")
        }
    }
    
    // MARK: - (Kakao)Logout
    func kakaoSocialLogOut() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("kakaoSocialLogOut() success.")
            }
        }
    }
}

extension SocialLoginViewModel {
    enum TokenCheckingState {
        case checking, available, unavailable
    }
}



