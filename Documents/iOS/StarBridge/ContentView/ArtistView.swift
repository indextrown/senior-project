//
//  ArtistView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-07.
//

import SwiftUI

struct ArtistView: View {
    @State private var artistArr: [Api.ImageData] = []
    @State private var isLoading = true
    private var artistlist = [
        "ive", "nct", "newjeans", "bts"
    ]
        
    var body: some View {
        GeometryReader{ geometry in
            ScrollView{
                VStack{
                    Text("\(artistlist.count)팀의 아티스트를")
                    Text("스타브릿지에서 만나볼 수 있어요")
                }
                .font(.system(size: 28, weight: .heavy))
                .foregroundColor(.black)
                .padding(.top, 100)
                VStack{
                    Text("지금 관심 있는 아티스트를 선택하고")
                    Text("스케줄, 실시간 차트, M/V 조회수, 인기 콘텐츠를 확인해보세요")
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(.vertical, 20)
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)  // ProgressView 크기 조정
                            .padding(.top, 100)
                        Text("아티스트 데이터를 불러오는 중...")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    }
                }
                else {
                    ScrollView(.horizontal){    // 자동으로 돌아가는 가로형 ScrollView 구현 예정
                        HStack(spacing: 10){
                            ForEach(artistArr, id: \.self){ artist in
                                VStack{
                                    if let imageData = artist.imageData {
                                        if let image = api.loadImage(from: imageData) {
                                            Image(uiImage: image)
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(40)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
        }
        .onAppear{
            Task{
                for artist in artistlist {
                    if let imageData = await api.fetchData(for: ["Content": "image", "filename": "\(artist)"]){
                        if let tmp: Api.ImageData = imageData.values.first?.first?.imageData {
                            artistArr.append(tmp)
                        }
                    }
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    ArtistView()
}
