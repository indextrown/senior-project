//
//  ContentView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-06-30.
//

import SwiftUI

struct ContentView: View {
    @State private var currentView: activeView = .CafeView
    
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
                            
                        Spacer()
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .onTapGesture { //  누적된 알람을 보여주는?
                                
                            }
                            
                    }
                    .padding(.horizontal)
                    .padding()
                    
                    Group {
                        switch currentView {
                        case .BulletinBoardView:
                            BulletinBoardView()
                        case .CafeView:
                            CafeView()
                        case .ProfileView:
                            ProfileView()
                        case .ScheduleView:
                            ScheduleView()
                        }
                    }
                    .frame(width: geometry.size.width)
                    
                    HStack{
                        Group{
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
                            Spacer()
                            VStack{
                                Group{
                                    Image(systemName: "gearshape")
                                        .font(.system(size: 20))
                                    Text("설정")
                                        .font(.system(size: 10))
                                }
                                .foregroundColor(currentView == .ProfileView ? .pink : .black)
                            }
                            .onTapGesture {
                                currentView = .ProfileView
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
        .ignoresSafeArea(.keyboard)
    }
}

enum activeView {
    case  BulletinBoardView, CafeView, ProfileView, ScheduleView
}


#Preview {
    ContentView()
}
