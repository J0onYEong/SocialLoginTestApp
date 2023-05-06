//
//  LoginScreen.swift
//  SocialLoginTestApp
//
//  Created by 최준영 on 2023/05/05.
//

import SwiftUI



struct LoginScreen: View {
    @StateObject var socialLogin = SocialLoginViewModel()
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Button("유저정보 가져오기") {
                    socialLogin.getUserInfo()
                }
                
                Button {
                    socialLogin.kakaoSocialLogin()
                } label: {
                    Image("kakao_login_medium_narrow")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 185, height: 45)
                }
                
                Button("로그아웃") {
                    socialLogin.kakaoSocialLogOut()
                }
            }
            .position(x: geo.size.width/2, y: geo.size.height/2)
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
