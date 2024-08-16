//
//  MyAppDelegate.swift
//  Social_Login_SwiftUI
//
//  Created by 김동현 on 8/15/24.
//

import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

class MyAppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        print("App key: \(kakaoAppKey)")

        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        return true
    }
    
    // kakao url을 타는 부분
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }

        return false
    }
    
    // MyappDelegate에서 SceneDelegate 클래스를 사용하도록 confiration 서정 필요
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration =  UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        
        // 내가 만든 MyAppDelegate SceneDelegate을 쓰겠다
        sceneConfiguration.delegateClass = MyAppDelegate.self
        return sceneConfiguration
    }
}

