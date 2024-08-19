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
            ScrollViewReader{ scrollViewProxy in
                NavigationView{
                    VStack{
                        HStack{
                            Button{
                                currentView = "blipView"
                            } label:{
                                TextView("blip", size: 30, weight: .bold)
                            }
                            TextView("Artists", size: 18, weight: currentView == "ArtistView" ? .bold : .regular)
                                .onTapGesture {
                                    scrollViewProxy.scrollTo("ArtistView")
                                    //                                currentView = "ArtistView"
                                }
                            TextView("Schedule", size: 18, weight: currentView == "ScheduleView" ? .bold : .regular)
                                .onTapGesture {
                                    scrollViewProxy.scrollTo("ScheduleView")
                                    //                                currentView = "ScheduleView"
                                }
                            TextView("Cafe", size: 18, weight: currentView == "CafeView" ? .bold : .regular)
                                .onTapGesture {
                                    scrollViewProxy.scrollTo("CafeView")
                                    //                                currentView = "CafeView"
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
                        .frame(height: geometry.size.height / 20)
                        .padding()
                    
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ArtistView()
                                    .frame(width: geometry.size.width)
                                    .id("ArtistView")
                                    .background(GeometryReader { geo in
                                        Color.clear.onChange(of: geo.frame(in: .global).minX) { newX in
                                            if abs(newX) < geometry.size.width / 2 {
                                                currentView = "ArtistView"
                                            }
                                        }
                                    })
                                
                                ScheduleView()
                                    .frame(width: geometry.size.width)
                                    .id("ScheduleView")
                                    .background(GeometryReader { geo in
                                        Color.clear.onChange(of: geo.frame(in: .global).minX) { newX in
                                            if abs(newX) < geometry.size.width / 2 {
                                                currentView = "ScheduleView"
                                            }
                                        }
                                    })
                            }
                        }
                        .onChange(of: currentView) { newView in
                            withAnimation{
                                scrollViewProxy.scrollTo(newView)
                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                    .background(.p3LightGray)
                    .padding(.top,  iPhonePointRes.currentDevicePortraitSafeArea()?.top)
                    .ignoresSafeArea()
                    .navigationBarHidden(true)
                }
            }
        }
   
        
        //
//        Button("카카오 로그아웃", action: {
//            kakaoAuthVM.kakaoLogout()
//        })
//        .onChange(of: kakaoAuthVM.isLoggedIn) { isLoggedIn in
//            if !isLoggedIn {
//                // 로그아웃 되었을 때, 화면 전환 처리
//                withAnimation {
//                    // 화면을 리셋하거나 다른 액션 수행
//                }
//            }
//        }
    }
}

// MARK: ContentView가 kakaoAuthVM 객체를 필요로 함
#Preview {
    ContentView(kakaoAuthVM: KakaoAuthVM())
}

//#Preview {
//    ContentView()
//}
