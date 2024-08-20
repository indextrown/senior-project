//
//  ArtistView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-07.
//

import SwiftUI

struct ArtistView: View {
    var body: some View {
        GeometryReader{ geometry in
            ScrollView{
                VStack{
                    Text("98팀의 아티스트를")
                    Text("블립에서 만나볼 수 있어요")
                }
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(.black)
                .padding(.top, 100)
                VStack{
                    Text("지금 관심 있는 아티스트를 선택하고")
                    Text("스케줄, 실시간 차트, M/V 조회수, 인기 콘텐츠를 확인해보세요")
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.gray)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                HStack{
                    VStack{
                        Button{
                            
                        }label: {
                            VStack{
                                TextView("아이브 사진")
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                TextView("아이브")
                            }
                        }
                    }
                    VStack{
                        Button{
                            
                        }label: {
                            VStack{
                                TextView("NCT 사진")
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                TextView("NCT")
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width)
        }
    }
}

#Preview {
    ArtistView()
}
