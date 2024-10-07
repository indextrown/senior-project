//
//  ContentView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-06-30.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var currentView: activeView = .CafeView
    @State private var showingBellView = false  // 새로운 상태 변수 추가
   
    
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
                        
                        // MARK: - 기존 emojiLogo 방식처럼 하려고 했으나 알림화면은 onTapGesture보다 아래 방식이 낫다고 판단하였음
                        // 벨 아이콘을 누르면 NoticeView로 이동
                        NavigationLink(destination: BellView()) {
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
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



struct BellView: View {
    @State private var newKeyword = ""                  // 새 키워드를 입력받기 위한 상태 변수
    @State private var bellArray = [BellItem]()
    
    var body: some View {
        VStack(spacing: 0) {
            List(bellArray.reversed()) { bell in  // bellArray를 List에 바인딩
                VStack(alignment: .leading) {
                    Text(bell.keyword)
                        .font(.headline)
                    Text(bell.title)
                        .font(.subheadline)
                    Text(bell.content)
                        .font(.subheadline)
                }
                .onTapGesture {
                    // 링크를 클릭 시 처리
                    if let url = URL(string: bell.link) {
                        UIApplication.shared.open(url)
                    }
                }

                .swipeActions {
                    Button(role: .destructive) {
                        bellArray.removeAll { $0.id == bell.id }
                        
                        // Firebase에서 제거하는 작업 추가 가능
                        Task { // 여기다 firebase에 데이터 수정하는 거 넣으면 될듯
                            await removeBellItemFromFirestore(bellItem: bell)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .background(Color.p3LightGray)
        .onAppear {
            Task {
                do {
                    let array = try await fetchBellArrayFromFirestore()  // Firebase에서 bellArray 가져오기
                    bellArray = array
                }
                catch {
                    print("데이터 가져오기 실패: \(error)")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("키워드 알림")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
        }
    }
    
    func removeBellItemFromFirestore(bellItem: BellItem) async {
        await withCheckedContinuation { continuation in
            let db = Firestore.firestore()
            
            guard let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId") else {
                print("kakaoUserId가 없습니다")
                continuation.resume() // 종료 지점 추가
                return
            }
            
            let docRef = db.collection("user").document(kakaoUserId)
            
            // BellArray에서 해당 bellItem을 삭제
            docRef.updateData([
                "BellArray": FieldValue.arrayRemove([[
                    "date": bellItem.content,
                    "keyword": bellItem.keyword,
                    "title": bellItem.title,
                    "link": bellItem.link
                ]])
            ]) { error in
                if let error = error {
                    print("알림 항목 제거 중 오류 발생: \(error)")
                } else {
                    print("알림 항목이 성공적으로 제거되었습니다.")
                }
                continuation.resume() // 종료 지점 추가
            }
        }
    }
    
    // Firestore에서 데이터를 가져오는 함수
    func fetchBellArrayFromFirestore() async throws -> [BellItem] {
        let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
        
        if kakaoUserId == nil {
            return [BellItem]()
        }

        let db = Firestore.firestore()
        let docRef = db.collection("user").document(kakaoUserId!)

        return try await withCheckedThrowingContinuation { continuation in
            docRef.getDocument { document, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let document = document, document.exists else {
                    continuation.resume(returning: [])
                    return
                }

                let data = document.data()
                
                if let bellArray = data?["BellArray"] as? [[String: Any]] {
                    let bellItems: [BellItem] = bellArray.compactMap { item in
                        if let content = item["date"] as? String,
                           let keyword = item["keyword"] as? String,
                           let title = item["title"] as? String,
                           let link = item["link"] as? String{
                            return BellItem(content: content, keyword: keyword, title: title, link: link)
                        }
                        return nil
                    }
                    continuation.resume(returning: bellItems)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }
}

struct BellItem: Identifiable {
    let id = UUID().uuidString  // 각 항목에 고유 ID를 부여
    let content: String
    let keyword: String
    let title: String
    let link: String
}
