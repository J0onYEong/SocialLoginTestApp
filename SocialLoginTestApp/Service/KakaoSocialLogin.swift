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

enum UserInfoError: Error {
    case tokenError
    case noData
    case otherError(error: Error)
}

enum LoginError: Error {
    case otherError(error: Error)
}

enum TokenCheckingError: Error {
    case tokenUnavailable
}


class KakaoSocialLogin {
    
    private init() { }
    
    static let shared = KakaoSocialLogin()
    
    // MARK: - 이메일 가져오기
    func getUserEmail(completion: @escaping (Result<String, UserInfoError>) -> ()) {
        if (AuthApi.hasToken()) {
            UserApi.shared.me { user, error in
                if let error = error {
                    completion(.failure(.otherError(error: error)))
                    return;
                }
                
                if let user = user, let email = user.kakaoAccount?.email {
                    completion(.success(email))
                } else {
                    completion(.failure(.noData))
                }
            }
        } else {
            // 토큰이 없음으로 로그인이 필요함
            completion(.failure(.tokenError))
        }
    }
    
    // MARK: - (Kakao)Login
    func logIn(completion: @escaping (Result<OAuthToken, LoginError>) -> ()) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 앱으로 로그인 요청
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error = error {
                    completion(.failure(.otherError(error: error)))
                } else {
                    completion(.success(token!))
                }
            }
        } else {
            // 브라우저를 통해 로그인
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error = error {
                    completion(.failure(.otherError(error: error)))
                } else {
                    completion(.success(token!))
                }   
            }
        }
    }
    
    // MARK: - (Kakao)Logout
    func logOut(completion: @escaping () -> ()) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                completion();
                print("kakaoSocialLogOut() success.")
            }
        }
    }
    
    // MARK: - (Kakao)토큰유효성 검사
    func checkTokenAvailability(completion: @escaping (Result<OAuthToken, TokenCheckingError>) -> ()) {
        if (AuthApi.hasToken()) {
            //토큰이 존재함으로 토큰을 refresh
            AuthApi.shared.refreshToken { token, error in
                if let error = error {
                    //refresh토큰도 말료된 상태 재로그인 필요
                    return completion(.failure(.tokenUnavailable))
                }
                return completion(.success(token!))
            }
        } else {
            //토큰없음
            completion(.failure(.tokenUnavailable))
        }
    }
}



