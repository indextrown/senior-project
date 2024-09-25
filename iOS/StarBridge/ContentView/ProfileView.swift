//
//  ProfileView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI

struct ProfileView: View {
    @State private var nickname = ""
    @State private var keywordAlarm = true // 나중에 Firebase에 설정을 저장해야하지 않을까..
    @State private var logout = false
    @State private var isLoading = true
    @StateObject private var kakaoAuthVM = KakaoAuthVM.shared
    
    var body: some View {
        GeometryReader{ geometry in
                ScrollView{
                    if !isLoading {
                        LazyVStack{
//                            NavigationLink(destination: ()) {
                                HStack {
                                    Text("로그인 정보")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(nickname)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.white)
                                )
//                            }
//                                .navigationTitle(Text(""))
                                .padding([.horizontal, .bottom])
                            
                            VStack(spacing: 0) {
                                Toggle(isOn: $keywordAlarm) {
                                    Text("키워드 알람")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                                .padding(.trailing)
                                
                                Rectangle()
                                    .fill(Color.p3LightGray)
                                    .frame(height: 2)
                                    .padding([.horizontal, .bottom])
                                
                                NavigationLink(destination: KeywordSettingView()) {
                                    HStack {
                                        Group {
                                            Image(systemName: "chevron.right")
                                                .rotationEffect(.degrees(135))
                                            Text("키워드 설정")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                        .foregroundColor(.black)
                                    }
                                }
                                .navigationTitle(Text(""))
                                .padding([.horizontal, .bottom])
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                            )
                            .padding([.horizontal, .bottom])
                            
                            NavigationLink(destination: UserPostsView(nickname: $nickname)) {
                                HStack {
                                    Group {
                                        Text("내가 올린 글")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                            .navigationTitle(Text(""))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                            )
                            .padding([.horizontal, .bottom])
 
                            Text("로그아웃")
                                .foregroundColor(.pink)
                                .onTapGesture {
                                    logout = true
                                }
                                .alert(isPresented: $logout) {
                                    Alert(
                                        title: Text("로그아웃"),
                                        message: Text("정말 로그아웃 하시겠습니까?"),
                                        primaryButton: .destructive(Text("로그아웃"), action: {
                                            Task {
                                                await kakaoAuthVM.handleKakaoLogout()
                                            }
                                        }),
                                        secondaryButton: .cancel(Text("취소"))
                                    )
                                }
                        }
                    }
                }
                .frame(width: geometry.size.width)
                .background(.p3LightGray)
                .onAppear {
                    Task {
                        do {
                            let array = try await fetchArrayFromFirestore(forKey: "nickname")
                            nickname = array.first ?? ""
                        
//                            array = try await fetchArrayFromFirestore(forKey: "keywordAlarm")
//                            keywordAlarm = array.first == "true" ? true : false
                            isLoading = false
                        } catch {
                            print("데이터 가져오기 실패: \(error)")
                        }
                    }
                }
            
        }
    }
}

struct KeywordSettingView: View {
    @State private var keywords = [String]()
    
    var body: some View {
        VStack(spacing: 0) {
            List(keywords, id: \.self) { keyword in
                HStack {
                    Text(keyword)
                    Spacer()
                }
                .swipeActions {
                    Button(role: .destructive) {
                        keywords.removeAll { $0 == keyword }
                        Task { // 여기다 firebase에 데이터 수정하는 거 넣으면 될듯
                            
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
                    let array = try await fetchArrayFromFirestore(forKey: "keyword")
                    keywords = array.map {
                        $0.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                    }
                    .sorted()
                }
                catch {
                    print("데이터 가져오기 실패: \(error)")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("키워드 설정")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "plus")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .onTapGesture {
                        // 추가할 작업을 여기에 구현
                    }
            }
        }
    }
}



struct UserPostsView: View {
    @Binding var nickname: String
    @State private var isLoading = true
    @State private var contents: [String: Api.BBoardData] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)
                        Text("게시판 데이터를 불러오는 중...")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                        Spacer()
                    }
                    .frame(height: geometry.size.height)
                }
                else {
                    ForEach(contents
                        .sorted{
                            if let key1 = Int($0.key), let key2 = Int($1.key) {
                                return key1 > key2
                            }
                            return false
                        }
                        .compactMap{$0.value}, id: \.self) { content in
                            LazyVStack{
                                NavigationLink(destination: BulletinBoardDetailView(detail: content)){
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text(content.title ?? "")
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                            HStack {
                                                Text(content.nickname ?? "")
                                                Text(showDate(date: content.post_date))   //글쓴 날짜가 오늘과 같다면 쓴 시간만 표시하고 반대면 날짜만
                                            }
                                        }
                                        .foregroundStyle(Color.black)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 80)
                                    .background(.white)
                                    .cornerRadius(15)
                                    .navigationTitle("")
                                }
                                .navigationTitle(Text(""))
                            }
                            .padding()
                        }
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear {
                Task {
                    repeat {
                        if let data = await api.fetchData(for: ["Content": "bboard", "nickname": nickname]){
                            contents = data.compactMapValues { value in
                                value.first?.bboardData
                            }
                        }
                    }
                    while contents.isEmpty
                    isLoading = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("내가 올린 글")
            .font(.system(size: 20))
            .foregroundColor(.black)
                }
            }
        }
    }
    
    private func showDate(date dateString: String?) -> String {
        guard let dateString = dateString, !dateString.isEmpty else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd / HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = String(format: "%02d", calendar.component(.month, from: date))
        let day = String(format: "%02d", calendar.component(.day, from: date))
        let hour = String(format: "%02d", calendar.component(.hour, from: date))
        let minute = String(format: "%02d", calendar.component(.minute, from: date))
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        if today == "\(year)-\(month)-\(day)" {
            return "\(hour):\(minute)"
        }
        
        return "\(String(format: "%02d", year % 100)).\(month).\(day)"
    }
}



//Button("알림 보내기") {
//    // 알림 권한 요청
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//        if granted {
//            print("알림 권한 허용됨")
//            Task {
//                for detail in details {
//                    sendNotification(detail: detail)
//                    try await Task.sleep(nanoseconds: 500_000_000)
//                }
//            }
//        } else {
//            print("알림 권한 거부됨")
//        }
//    }
//}

#Preview {
//    ProfileView()
    KeywordSettingView()
}
