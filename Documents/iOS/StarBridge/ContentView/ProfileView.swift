//
//  ProfileView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var kakaoAuthVM = KakaoAuthVM.shared
    var body: some View {
        GeometryReader{ geometry in
            ScrollView{
                VStack{
                    Text("This is ProfileView")
                        .foregroundColor(.black)
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
                            .cornerRadius(13)
                    }
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("설정")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
