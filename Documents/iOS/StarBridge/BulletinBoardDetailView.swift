//
//  BulletinBoardDetailView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-27.
//

import SwiftUI

let testData = Api.BBoardData(
    id: "1",
    title: "New Album Release",
    content: "The new album is amazing! Every track is a hit.",
    post_date: "2024-08-25 14:30:00",
    artist: "StarGroup",
    nickname: "Fan123",
    likes: "150"
)


struct BulletinBoardDetailView: View {
    var detail: Api.BBoardData
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(detail.artist ?? "")
                        Text(detail.title ?? "")
                    }
                    Spacer()
                }
                .padding([.horizontal, .bottom])
                
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    VStack(alignment: .leading) {
                        Text(detail.nickname ?? "")
                        HStack {
                            Text(detail.post_date ?? "")
                            Spacer()
                            Image(systemName: "heart.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.pink)
                            Text(detail.likes ?? "")
                        }
                    }
                    Spacer()
                }
                .padding([.horizontal, .bottom])
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .padding([.horizontal, .bottom])
                
                HStack {
                    Text(detail.content ?? "")
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .background(Color.p3LightGray)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("게시글")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
        }
        .navigationBarTitleDisplayMode(.inline)  // inline 모드로 변경
    }
}


#Preview {
    BulletinBoardDetailView(detail: testData)
}
