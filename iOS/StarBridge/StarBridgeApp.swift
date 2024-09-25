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
    
    @State private var dataCount = 0

    var body: some Scene {
        WindowGroup {
            Group {
                if kakaoAuthVM.isLoggedIn {
                    if !kakaoAuthVM.isLoading {
                        if kakaoAuthVM.hasProfile {
                            ContentView()
                                .onAppear {
                                    let request = BGAppRefreshTaskRequest(identifier: "checkNewDataFromServer")
                                    request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
                                    do {
                                        try BGTaskScheduler.shared.submit(request)
                                        print("된다")
                                    }
                                    catch(let err) {
                                        print("스케줄 에러 \(err)")
                                    }
                                }
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
        .backgroundTask(.appRefresh("checkNewDataFromServer")) {
            Task {
                if let doesNewData = await api.fetchData(for: ["Content": "cafe", "all": "true"]) { //데이터 모두를 가져와서
                    if await dataCount > 0 { // 이때만 알림
//                        sendNotification()
                    }
                    await MainActor.run {
                        dataCount = max(dataCount, doesNewData.values.flatMap {$0}.count)
                    }
                }
            }
        }
    }
}
