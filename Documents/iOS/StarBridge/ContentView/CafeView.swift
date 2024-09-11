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
                                            Text(cafe.uploader ?? "")
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

#Preview {
    CafeView()
}
