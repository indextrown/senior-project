//
//  StarBridgeApp.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-06-30.
//

import SwiftUI


@main
struct StarBridgeApp: App {
    // MARK: AppDelegate 사용
    @UIApplicationDelegateAdaptor var appDelegate: MyAppDelegate
    
    // MARK: 앱 전체에서 로그인 상태를 관리
    @StateObject var kakaoAuthVM = KakaoAuthVM()
    
    var body: some Scene {
        WindowGroup {
            if kakaoAuthVM.isLoggedIn {
                ContentView(kakaoAuthVM: kakaoAuthVM)
            } else {
                LoginView(kakaoAuthVM: kakaoAuthVM)
            }
        }
//                WindowGroup {
//                    ContentView()
//        
//                }
    }
}
