//
//  MySceneDelegate.swift
//  Social_Login_SwiftUI
//
//  Created by 김동현 on 8/15/24.
//

import Foundation
import KakaoSDKAuth
import UIKit

// MyappDelegate에서 SceneDelegate 클래스를 사용하도록 confiration 서정 필요
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
