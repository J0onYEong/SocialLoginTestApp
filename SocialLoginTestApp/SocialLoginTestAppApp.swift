//
//  SocialLoginTestAppApp.swift
//  SocialLoginTestApp
//
//  Created by 최준영 on 2023/05/05.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct SocialLoginTestAppApp: App {
    @ObservedObject var authentication = AuthenticationObject()
    
    init() {
        KakaoSDK.initSDK(appKey: KakaoApp.nativeAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            MainScene()
                .environmentObject(authentication)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
