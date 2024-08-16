//
//  ContentView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-06-30.
//

import SwiftUI
import UIKit
import KakaoSDKAuth

struct ContentView: View {
    // MARK: 뷰모델을 state로 가져올 때 사용
    // MARK: App에서 주입된 kakaoAuthVM을 사용하도록 수정
    @ObservedObject var kakaoAuthVM: KakaoAuthVM
    
    // MARK: 현재 사용되지 않음(디버깅용)
    let loginStatusInfo: (Bool) -> String = { isLoggedIn in
        return isLoggedIn ? "로그인 상태" : "로그아웃 상태"
    }
     
    
    @State var currentView = "ArtistView"
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                ScrollViewReader{ ScrollViewProxy in
                    HStack{
                        Button{
                            
                        }label: {
                            TextView("blip", size: 30, weight: .bold)
                        }
                        Button{
                            ScrollViewProxy.scrollTo("ArtistView")
                            currentView = "ArtistView"
                        }label: {
                            TextView("Artists", size: 18)
                        }
                        Button{
                            ScrollViewProxy.scrollTo("ScheduleView")
                            currentView = "ScheduleView"
                        }label: {
                            TextView("Schedule", size: 18)
                        }
                        Button{
                           
                            currentView = "CafeView"
                        }label: {
                            TextView("Cafe", size: 18)
                        }
                        Spacer()
                        Button{
                            
                        }label: {
                            TextView("kpop radar", weight: .bold, color: Color.white)
                        }
                            .frame(width: 100, height: 40) //가로 세로 비율: 5: 2
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                        .padding()
                        .frame(height: geometry.size.height / 20)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ArtistView().frame(width: geometry.size.width)
                                .id("ArtistView")
                                .frame(width: geometry.size.width)
                            ScheduleView().frame(width: geometry.size.width)
                                .id("ScheduleView")
                                .frame(width: geometry.size.width)
                        }
                    }
                    
                }
            }
            .frame(width: geometry.size.width)
            .ignoresSafeArea()
            .padding(.top,  iPhonePointRes.currentDevicePortraitSafeArea()?.top)
            .background(.p3LightGray)
        }
        
        // 
        Button("카카오 로그아웃", action: {
            kakaoAuthVM.kakaoLogout()
        })
        .onChange(of: kakaoAuthVM.isLoggedIn) { isLoggedIn in
            if !isLoggedIn {
                // 로그아웃 되었을 때, 화면 전환 처리
                withAnimation {
                    // 화면을 리셋하거나 다른 액션 수행
                }
            }
        }
    }
}


// MARK: ContentView가 kakaoAuthVM 객체를 필요로 함
#Preview {
    ContentView(kakaoAuthVM: KakaoAuthVM())
}

//#Preview {
//    ContentView()
//}
