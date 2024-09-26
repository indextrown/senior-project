//
//  HomeView.swift
//  StarBridge
//
//  Created by 김동현 on 9/4/24.
//

import SwiftUI

struct HomeView: View {
    
    // 앱 전체 상태를 가져온다
    // @EnvironmentObject var kakaoAuthVM: KakaoAuthVM
    @StateObject private var kakaoAuthVM = KakaoAuthVM.shared
    
    var body: some View {
        
        VStack {
            Text("Welcome to Home!")
                .font(.largeTitle)
                .padding()
            
            // 홈 화면에 추가할 내용은 여기서 구현
            Button {
                Task {
                    await kakaoAuthVM.handleKakaoLogout()
                }
            } label: {
                Text("back")
                    .foregroundStyle(.black)
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    HomeView()
        .environmentObject(KakaoAuthVM.shared)
}
