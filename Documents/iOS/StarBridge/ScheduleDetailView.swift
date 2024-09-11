//
//  ScheduleDetailView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-19.
//

import SwiftUI
import UIKit

struct ScheduleDetailView: View {
    var detail: Api.SnsData
    
    init(detail: Api.SnsData) {
        self.detail = detail
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text(detail.title ?? "")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .lineLimit(3)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.p3LightGray)
                        .padding()
                    
                    HStack {
                        VStack {
                            Group {
                                Text("날짜")
                                Text("채널")
                            }
                            .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Group {
                                Text(detail.event_date ?? "")
                                Text(detail.id ?? "")
                            }
                            .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Group {
                            Image(systemName: "bell.badge")
                            Text("알림 추가")
                        }
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        Spacer()
                    }
                    .frame(height: 30)
                    .background(Color.clear)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .padding()
                }
                .background(.white)
                
                VStack {
                    Group {
                        Text(detail.detail ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                    .foregroundColor(.black)

                    Text("👇 보러 가기")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                    
                    if let link = detail.url {
                        Link(destination: URL(string: link)!) {
                            Text(link)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom)
                        }
                    }
                    
                    if let images = detail.photos {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(images, id: \.self) { imageString in
                                    if let image = api.loadImage(from: imageString) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(.p3LightGray)
        .navigationBarTitleDisplayMode(.inline) // inline 모드로 설정하여 툴바와 내용이 간격 없이 붙도록 함
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("스케줄")
        .font(.system(size: 20))
        .foregroundColor(.black)
            }
        }
    }
}



//#Preview {
//    ScheduleDetailView()
//}
