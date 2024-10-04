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
import Firebase
import FirebaseMessaging

class MyAppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject, MessagingDelegate {
    
    // MARK: - FCM 관련 로직 추가
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        // print("App key: \(kakaoAppKey)")

        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // gRPC 관련 환경 변수 설정 (GRPC_TRACE 제거)
        setenv("GRPC_VERBOSITY", "ERROR", 1)
        unsetenv("GRPC_TRACE") // GRPC_TRACE 환경 변수 제거
        
        // Firebase 디버그 로그 활성화
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        
        // MARK: - FCM 관련 로직 추가
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOption) { granted, error in
                if let error = error {
                    print("권한 요청 중 에러 발생: \(error.localizedDescription)")
                }
                
                /*
                if granted {
                    print("알림 권한이 허용되었습니다.")
                } else {
                    print("알림 권한이 거부되었습니다.")
                }
                 */
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // 메세징 델리겟 설정
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // APNs 토큰을 성공적으로 등록했는지 확인
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNs Device Token: \(deviceToken)")
    }
    
    // Kakao URL 핸들러
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    // SceneDelegate 설정
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}



@available(iOS 10, *)
extension MyAppDelegate {
    
    // 푸시 메시지가 앱이 켜져 있을 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        completionHandler([[.banner, .badge, .sound]])

    }
    
    
    // 푸시 메시지를 받았을 때 처리 (앱이 백그라운드에 있을 때도 처리)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
         completionHandler()
    }
    
    
    // MARK: - 토큰을 Firestore에 저장
    func saveFcmTokenToFirestore(token: String) async -> Bool {
        let key = "fcmtoken"
        return await saveStringToFirestore(key: key, value: token) // 토큰을 배열로 저장
    }
    
    // MARK: - 토큰을 기기에서 삭제
    func deleteFCMToken() {
        Messaging.messaging().deleteToken { error in
            /*
            if let error = error {
                print("FCM 토큰 삭제 중 오류 발생: \(error.localizedDescription)")
            } else {
                print("FCM 토큰이 성공적으로 삭제되었습니다.")
            }
             */
        }
    }
    
    // FCM 토큰 생성 함수
    func generateFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 생성 중 오류 발생: \(error.localizedDescription)")
            } else if let token = token {
                // print("FCM 토큰 생성 성공: \(token)")
                Task {
                    _ = await self.saveFcmTokenToFirestore(token: token) // 저장 시도
                    /*
                    if success {
                        print("FCM 토큰이 Firestore에 성공적으로 저장되었습니다.")
                    } else {
                        print("FCM 토큰 저장에 실패했습니다.")
                    }
                     */
                }
            }
        }
    }
}





//
// MARK: - FCM 관련 추가 로직(일단 삭제금지)
//
//extension MyAppDelegate {
//     // FCM 등록 토큰을 받았을 때
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("토큰을 받았다")
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        print(dataDict)
//        
//        if let token = fcmToken {
//            Task {
//                let success = await saveFcmTokenToFirestore(token: token) // 저장 시도
//                if success {
//                    print("FCM 토큰이 Firestore에 성공적으로 저장되었습니다.")
//                } else {
//                    print("FCM 토큰 저장에 실패했습니다.")
//                }
//            }
//        }
//    }
//    
//    // FCM 등록 토큰을 Firestore에 저장
//    private func saveFcmTokenToFirestore(token: String) async -> Bool {
//        let key = "fcmtoken"
//        return await saveArrayToFirestore(key: key, array: [token]) // 토큰을 배열로 저장
//    }
//}
//
