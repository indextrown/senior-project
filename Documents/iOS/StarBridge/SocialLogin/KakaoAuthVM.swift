//
//  KakaoAuthVM.swift
//  Social_Login_SwiftUI
//
//  Created by 김동현 on 8/15/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    
    // 로그아웃 동시성
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    // 로그인 동시성
    @MainActor
    func handleLoginWithKakaoTalkApp() async -> Bool {
        
        await withCheckedContinuation { continuation in
            // 카카오 앱을 통해 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    @MainActor
    func handleLoginWithKakaoAccount() async -> Bool {
        
        await withCheckedContinuation { continuation in
            // 카카오 웹뷰로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
                    _ = oauthToken
                    
                    continuation.resume(returning: true)
                }
            }
        }
    }
        
    // 로그아웃
    @MainActor
    func handleKakaoLogout() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    
    // UIApplication.connectedScenes must be used from main thread only
    // Task 그룹을 호출하는 쪽에 전부 @MainActior설정필요
    // 카카오톡 설치 여부 확인(최종 메서드)
    @MainActor
    func handleKakaoLogin() {
        Task {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
                
            } else { // 설치 안되어있을 때
                isLoggedIn = await handleLoginWithKakaoAccount()
            }
        }
    }
}

