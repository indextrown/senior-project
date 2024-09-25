////
////  MyAppDelegate.swift
////  Social_Login_SwiftUI
////
////  Created by 김동현 on 8/15/24.
////
//
//import Foundation
//import UIKit
//import KakaoSDKCommon
//import KakaoSDKAuth
//import Firebase
//import FirebaseMessaging
//
//
//class MyAppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//    // MARK: - FCM 관련 로직 추가
//    let gcmMessageIDKey = "gcm.message_id"
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
//        print("App key: \(kakaoAppKey)")
//
//        // Kakao SDK 초기화
//        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
//        
//        // firebase 초기화
//        FirebaseApp.configure()
//        
//        // MARK: - FCM 관련 로직 추가
//        // Setting Up Notifications...
//        // 원격 알림 등록
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            
//            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOption,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        
//        application.registerForRemoteNotifications()
//        
//        
//        // Setting Up Cloud Messaging...
//        // 메세징 델리겟
//        Messaging.messaging().delegate = self
//        
//        UNUserNotificationCenter.current().delegate = self
//        
//        return true
//    }
//    
//    // kakao url을 타는 부분
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        if (AuthApi.isKakaoTalkLoginUrl(url)) {
//            return AuthController.handleOpenUrl(url: url)
//        }
// 
//        return false
//    }
//    
//    // MyappDelegate에서 SceneDelegate 클래스를 사용하도록 confiration 설정 필요
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        let sceneConfiguration =  UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//        
//        // 내가 만든 MyAppDelegate SceneDelegate을 쓰겠다
//        sceneConfiguration.delegateClass = SceneDelegate.self
//        return sceneConfiguration
//    }
//    
//    
//}
//
//
//// MARK: - FCM관련 추가로직
//// Cloud Messaging...
//extension MyAppDelegate {
//    
//    // fcm 등록 토큰을 받았을 때
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//
//        print("토큰을 받았다")
//        // Store this token to firebase and retrieve when to send message to someone...
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        
//        // Store token in Firestore For Sending Notifications From Server in Future...
//        
//        print(dataDict)
//     
//    }
//}
//
//@available(iOS 10, *)
//extension MyAppDelegate {
//  
//    // 푸시 메세지가 앱이 켜져있을 때 나올떄
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              willPresent notification: UNNotification,
//                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
//                                -> Void) {
//      
//    let userInfo = notification.request.content.userInfo
//
//    
//    // Do Something With MSG Data...
//    if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//    }
//    
//    
//    print(userInfo)
//
//    completionHandler([[.banner, .badge, .sound]])
//  }
//
//    // 푸시메세지를 받았을 떄
//  func userNotificationCenter(_ center: UNUserNotificationCenter,
//                              didReceive response: UNNotificationResponse,
//                              withCompletionHandler completionHandler: @escaping () -> Void) {
//    let userInfo = response.notification.request.content.userInfo
//
//    // Do Something With MSG Data...
//    if let messageID = userInfo[gcmMessageIDKey] {
//        print("Message ID: \(messageID)")
//    }
//      
//    print(userInfo)
//
//    completionHandler()
//  }
//}
import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import Firebase
import FirebaseMessaging

class MyAppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    // MARK: - FCM 관련 로직 추가
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        print("App key: \(kakaoAppKey)")

        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        // Firebase 초기화
        FirebaseApp.configure()
        
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
                
                if granted {
                    print("알림 권한이 허용되었습니다.")
                } else {
                    print("알림 권한이 거부되었습니다.")
                }
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

// MARK: - FCM 관련 추가 로직
extension MyAppDelegate {
    
    // FCM 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("토큰을 받았다")
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        print(dataDict)
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

    // 푸시 메시지를 받았을 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        completionHandler()
    }
}
