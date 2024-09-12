//
//  CafeView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI
import UIKit

struct CafeView: View {
    @State private var cafeList: [String:[Api.CafeData]] = [:]
    @State private var isLoading = true
    @State private var celebrities: [String] = []   //  api로 받아온 연예인들 집합
    @State private var filterList: [String] = []    //  알고싶은 연예인들만 모음
    @State private var filterWordSize: CGFloat = .zero
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        Text("연예인")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            filterWordSize = geo.size.width
                                        }
                                }
                            )
                        if isLoading {
                            Spacer()
                        }
                        else {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(filterList, id: \.self) { celebrity in
                                        Text(celebrity)
                                            .foregroundColor(.black)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 50)
                    Rectangle()
                        .frame(width: .infinity, height: 1)
                        .border(Color.gray.opacity(0.4))
                    HStack() {
                        HStack {
                            Text("날짜")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .frame(width: filterWordSize)
                        Spacer()
                    }
                    .frame(height: 50)
                }
                .padding(.horizontal)
                .background(.white)
                .cornerRadius(15)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack {
                        if !isLoading {
                            ForEach(cafeList.values.flatMap {$0}, id: \.self) { cafe in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Group {
                                            Text(cafe.celebrity ?? "")
                                            Text("\(cafe.start_date ?? "") ~ \(cafe.end_date ?? "")")
                                            Text(cafe.place ?? "")
                                        }
                                        .foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .frame(height: 120)
                                .background(.white)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .navigationTitle("")
                                .onTapGesture {
                                    if let url = URL(string: cafe.post_url ?? "") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                        }
                        else {
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                    .scaleEffect(1.5)  // ProgressView 크기 조정
                                    .padding(.top, 100)
                                Text("생일카페 데이터를 불러오는 중...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 20)
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear {
                Task {
                    if let cafeData = await api.fetchData(for: ["Content": "cafe", "all": "_"]) {
                        cafeList = cafeData.mapValues { values in
                            values.compactMap {$0.cafeData}
                        }
                    }
                    celebrities = Array(cafeList.keys)
                    isLoading = false
                }
            }
        }
    }
}

func sendNotification() {
    // 알림 콘텐츠 생성
    let content = UNMutableNotificationContent()
    content.title = "푸시 알림 제목"
    content.body = "이것은 버튼을 눌러서 보낸 알림입니다."
    content.sound = UNNotificationSound.default
    
    // 5초 후에 알림이 뜨도록 트리거 설정
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    // 알림 요청 생성
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    // 알림 요청을 Notification Center에 추가
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("알림 요청 에러: \(error.localizedDescription)")
        } else {
            print("알림이 성공적으로 등록됨")
        }
    }
}

#Preview {
    CafeView()
}
