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
    
    
    @Published var isLoggedIn: Bool = false {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    @Published var kakaoUserId: String? {
        didSet {
            UserDefaults.standard.set(kakaoUserId, forKey: "kakaoUserId")
        }
    }
    @Published var hasProfile: Bool = false {
        didSet {
            UserDefaults.standard.set(hasProfile, forKey: "hasProfile")
        }
    }
    @Published var isLoading: Bool = true
    
    static let shared = KakaoAuthVM()
    
    
    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
        self.hasProfile = UserDefaults.standard.bool(forKey: "hasProfile")
        self.isLoading = false
    }
    
    
    // 로그아웃 동시성
    @MainActor
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
                
                // MARK: - UserDefaults
                kakaoUserId = nil
                hasProfile = false
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                UserDefaults.standard.removeObject(forKey: "kakaoUserId")
                UserDefaults.standard.removeObject(forKey: "hasProfile")
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
                    
                    //self.fetchUserId()
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

                    //self.fetchUserId()
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
                        // 메인 스레드에서 상태 업데이트
                        DispatchQueue.main.async {
                            self.isLoggedIn = false
                        }
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
        // MARK: - 순서대로 동작
        // MARK: - await은 호출지점에서 비동기 처리를 기다리게 된다 -> 동기적인 코드처럼 보인다
        // MARK: - 각 작업이 완료될 때까지 기다리기 때문에 코드 흐름이 순서대로 동작
        // MARK: - await와 비동기 작업:
        // MARK: - await는 비동기 함수가 완료될 때까지 현재 작업을 일시 중지합니다. 이 대기 상태는 메인 스레드를 차단하지 않으며, 비동기 작업이 완료되기까지 다른 스레드에서 계속 실행됩니다.
        // MARK: - 비동기 작업이 백그라운드 스레드에서 수행되며, 이 과정에서 메인 스레드는 다른 작업을 계속할 수 있습니다.
        Task {
            
            isLoading = true
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                // 카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
            } else { // 설치 안되어있을 때
                isLoggedIn = await handleLoginWithKakaoAccount()
            }

            if isLoggedIn {
                // 카카오 UID
                kakaoUserId = await fetchUserId()?.id
                
                print("결과 출력: \(kakaoUserId ?? "None")")
                
                // 파이어베이스 접근
//                hasProfile = await checkAndSaveUser(uid: kakaoUserId ?? "None", email: "None")
                
                print("프로필 디버깅: \(hasProfile)")
                
            }
            isLoading = false // 비동기 작업 왠료
            
            
        }
    }
    // MARK: - UserApI 내부스코프에서는 코드가 순차적으로 실행되지만 비동기 작업이 포함된경우 해당 작업이 만료될때까지 기다리지 않는다
    // MARK: - fetchUserId() 같은경우 호출이되더라도 끝나지 않고 바로 continuation.resume가 진행될 수 있다
    // MARK: - await withCheckedContinuation을 사용하여 비동기 작업의 결과를 동기적으로 기다린다
    // kakao uid 정보 가져오기
    private func fetchUserId() async -> UserInfo? {
        // 데이터를 받아올때까지 기다리겠다 await
        await withCheckedContinuation { continuation in
            UserApi.shared.me { (user, error) in
                if let error = error {
                    print("Error fetching user info: \(error)")
                    continuation.resume(returning: nil)     // 비동기작업이 완료되면 호출
                } else if let user = user {
                    let userId = String(user.id ?? 0) // Kakao User ID 가져오기
                    let userEmail = user.kakaoAccount?.email ?? "Unknown"
                    let userInfo = UserInfo(id: userId, email: userEmail)

                    // checkAndSaveUser 호출 후 결과를 기다림
                    Task {
                        _ = await self.checkAndSaveUser(uid: userId, email: userEmail)
                        continuation.resume(returning: userInfo) // 비동기작업이 완료되면 호출
                    }
                    
                    
                }
            }
        }
    }
    
    private func checkAndSaveUser(uid: String, email: String) async -> Bool {
        await withCheckedContinuation { continuation in
            MyFirestore.shared.getUser(uid: uid) { document, error in
                if let document = document, document.exists {
                    print("User found in Firestore: \(document.data()!)")
                    self.hasProfile = true
                    continuation.resume(returning: true)
                } else {
                    print("(출력만)User does not exist in Firestore. Saving new user.")
                    self.hasProfile = false
                    //self.saveNewUser(uid: uid, email: email)
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    private func saveNewUser(uid: String, email: String) {
        MyFirestore.shared.saveUser(uid: uid, email: email) { error in
            if let error = error {
                print("Error saving user to Firebase \(error)")
            } else {
                print("User successfully saved to Firestore.")
            }
        }
    }
}
