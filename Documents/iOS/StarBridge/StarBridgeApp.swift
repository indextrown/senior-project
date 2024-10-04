//
//  StarBridgeApp.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-06-30.
//

import SwiftUI
import BackgroundTasks

@main
struct StarBridgeApp: App {
    // 상태 객체를 생성
    @ObservedObject private var kakaoAuthVM = KakaoAuthVM.shared
    
    // AppDelegate 사용
    //@UIApplicationDelegateAdaptor var appDelegate: MyAppDelegate
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            Group {
                if kakaoAuthVM.isLoggedIn {
                    if !kakaoAuthVM.isLoading {
                        if kakaoAuthVM.hasProfile {
                            ContentView()
                        } else {
                            ProfileSetupView()
                        }
                    }
                } else {
                    LoginView()
                }
            }
            .environmentObject(kakaoAuthVM)
            
        }
    }
}

