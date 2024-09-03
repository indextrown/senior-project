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
     
    @State private var currentView: activeView = .ArtistView
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                VStack{
                    HStack{
                        Image("emojiLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .onTapGesture { //  팔로우한 아티스트들을 sheet 방식으로 보여줌(상단에 검색창 포함해야함)
                                
                            }
                            .padding()
                        Spacer()
                        Image(systemName: "bell")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .onTapGesture {
                                
                            }
                            .padding()
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 25, height: 25)
                        .padding(.trailing)
                    }
                    
                    Group {
                        switch currentView {
                        case .ArtistView:
                            ArtistView()
                        case .ScheduleView:
                            ScheduleView()
                        case .CafeView:
                            CafeView()
                        case .BulletinBoardView:
                            BulletinBoardView()
                        }
                    }
                    .frame(width: geometry.size.width)
                    
                    HStack{
                        Group{
                            VStack{
                                Group{
                                    Image(systemName: "play.tv")
                                        .font(.system(size: 20))
                                    Text("아티스트")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(currentView == .ArtistView ? .pink : .black)
                            }
                            .onTapGesture {
                                currentView = .ArtistView
                            }
                            Spacer()
                            VStack{
                                Group{
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 20))
                                    Text("스케줄")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(currentView == .ScheduleView ? .pink : .black)
                            }
                            .onTapGesture {
                                currentView = .ScheduleView
                            }
                            Spacer()
                            VStack{
                                Group{
                                    Image(systemName: "gift")
                                        .font(.system(size: 20))
                                    Text("생일카페")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(currentView == .CafeView ? .pink : .black)
                            }
                            .onTapGesture {
                                currentView = .CafeView
                            }
                            Spacer()
                            VStack{
                                Group{
                                    Image(systemName: "note.text")
                                        .font(.system(size: 20))
                                    Text("게시판")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(currentView == .BulletinBoardView ? .pink : .black)
                            }
                            .onTapGesture {
                                currentView = .BulletinBoardView
                            }
                        }
                        .foregroundColor(.black)
                    }
                    .frame(height: geometry.size.height / 20)
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .background(.white)
                }
                .frame(width: geometry.size.width)
                .background(.p3LightGray)
                .padding(.top,  geometry.safeAreaInsets.top / 2)
                .ignoresSafeArea()
                .navigationBarHidden(true)
                
            }
            .accentColor(.black)
        }
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

enum activeView {
    case ArtistView, ScheduleView, CafeView, BulletinBoardView
}

// Remove navigationTitle permanently all views
//extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}



// MARK: ContentView가 kakaoAuthVM 객체를 필요로 함
//#Preview {
//    ContentView(kakaoAuthVM: KakaoAuthVM())
//}

//#Preview {
//    ContentView()
//}
