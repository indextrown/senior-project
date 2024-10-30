//
//  ProfileView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI
import FirebaseMessaging
import UserNotifications
import FirebaseFirestore

struct ProfileView: View {
    @State private var nickname = ""
    @State private var keywordAlarm = UserDefaults.standard.bool(forKey: "keywordAlarm") // UserDefaults에서 상태 불러오기
    @State private var logout = false
    @State private var isLoading = true
    @StateObject private var kakaoAuthVM = KakaoAuthVM.shared
    @EnvironmentObject var appDelegate: MyAppDelegate // AppDelegate를 환경 객체로 가져오기

    var body: some View {
        GeometryReader{ geometry in
                ScrollView{
                    if !isLoading {
                        LazyVStack{
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
                                .padding([.horizontal, .bottom])
                            
                            VStack(spacing: 0) {
                                Toggle(isOn: $keywordAlarm) {
                                    Text("키워드 알람")
                                        .foregroundColor(.black)
                                        .padding()
                                }
                                .padding(.trailing)
                                // MARK: - Index
                                .onChange(of: keywordAlarm) { newValue in
                                    if newValue {
                                        // 알림 활성화
                                        UserDefaults.standard.set(true, forKey: "keywordAlarm")
                                        // print("활성화토글: \(keywordAlarm)")
                                        // generateFCMToken()
                                        appDelegate.generateFCMToken()

                                    } else {
                                        // 알림 비활성화
                                        UserDefaults.standard.set(false, forKey: "keywordAlarm")
                                        // print("비활성화토글: \(keywordAlarm)")
                                        // deleteFCMToken()
                                
                                        appDelegate.deleteFCMToken()
                                        
                                    }
                                    
                                    // MARK: 파이어베이스 관련 함수 살려두기로 결정
                                    // Task {
                                    //    await saveKeywordAlarmToFirestore(isEnabled: newValue)
                                    // }
                                }
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.4))
                                    .frame(height: 1)
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
                                .navigationTitle("")
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
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.white)
                            )
                            .padding([.horizontal, .bottom])
                            .navigationTitle("")
 
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
                        
                            // array = try await fetchArrayFromFirestore(forKey: "keywordAlarm")
                            // keywordAlarm = array.first == "true" ? true : false
                            
                            // MARK: - 키워드 알람 설정 불러오기
                            // let alarmArray = try await fetchArrayFromFirestore(forKey: "keywordAlarm")
                            // keywordAlarm = alarmArray.first == "true" ? true : false
                            keywordAlarm = UserDefaults.standard.bool(forKey: "keywordAlarm")
                            
                            isLoading = false
                        } catch {
                            print("데이터 가져오기 실패: \(error)")
                        }
                    }
                }
            
        }
    }
    
    // MARK: - 파이어베이스에 알람 추가
    private func saveKeywordAlarmToFirestore(isEnabled: Bool) async {
        let value = isEnabled ? "true" : "false"
        _ = await saveArrayToFirestore(key: "keywordAlarm", array: [value])
    }
    
    
    
    private func saveFcmTokenToFirestore(token: String) async -> Bool {
        let key = "fcmtoken"
        return await saveStringToFirestore(key: key, value: token) // 토큰을 배열로 저장
    }

}


struct KeywordSettingView: View {
    @State private var keywords = [String]()
    @State private var newKeyword = ""                  // 새 키워드를 입력받기 위한 상태 변수
    @State private var showingAddKeywordSheet = false   // 키워드 추가 알림창 표시 상태
    
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
                        Task {
                            await removeKeywordFromFirestore(keyword: keyword)
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
                        showingAddKeywordSheet = true
                    }
            }
        }
        // MARK: - 알람방식
        .alert("키워드 추가", isPresented: $showingAddKeywordSheet, actions: {
            TextField("키워드 추가", text: $newKeyword)
            
            Button("추가", action: {
                Task {
                    if !newKeyword.isEmpty {
                        await addKeywordToFirestore(keyword: newKeyword)
                        keywords.append(newKeyword)
                        keywords.sort()
                        newKeyword = ""
                    }
                }
            })

            Button("취소", role: .cancel, action: { newKeyword = "" })
        }, message: {
            Text("원하는 키워드를 입력해주세요")
        })
    }
    
    func removeKeywordFromFirestore(keyword: String) async {
            await withCheckedContinuation { continuation in
                let db = Firestore.firestore()
                
                guard let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId") else {
                    print("kakaoUserId가 없습니다")
                    continuation.resume() // 종료 지점 추가
                    return
                }
                    
                let docRef = db.collection("user").document(kakaoUserId)
                
                docRef.updateData([
                    "keyword": FieldValue.arrayRemove([keyword])
                ]) { error in
                    if let error = error {
                        print("키워드 제거 중 오류 발생: \(error)")
                    } else {
                        print("키워드가 성공적으로 제거되었습니다.")
                    }
                    continuation.resume() // 종료 지점 추가
                }
            }
        }

        func addKeywordToFirestore(keyword: String) async {
            await withCheckedContinuation { continuation in
                let db = Firestore.firestore()
                
                guard let kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId") else {
                    print("kakaoUserId가 없습니다")
                    continuation.resume() // 종료 지점 추가
                    return
                }
                
                let docRef = db.collection("user").document(kakaoUserId)
                
                docRef.updateData([
                    "keyword": FieldValue.arrayUnion([keyword])
                ]) { error in
                    if let error = error {
                        print("키워드 추가 중 오류 발생: \(error)")
                    } else {
                        print("키워드가 성공적으로 추가되었습니다.")
                    }
                    continuation.resume() // 종료 지점 추가
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
                    if contents.isEmpty {
                        VStack {
                            Spacer()
                            Text("작성한 글이 없습니다.")
                                .foregroundColor(.gray)
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
                                    }
                                    .navigationTitle("")
                                }
                                .padding()
                            }
                    }
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear {
                Task {
                    var count = 0
                    while contents.isEmpty && count < 3 {
                        if let data = await api.fetchData(for: ["Content": "bboard", "nickname": nickname]){
                            contents = data.compactMapValues { value in
                                value.first?.bboardData
                            }
                        }
                        count += 1
                    }
                    if let nickname = contents.values.first?.nickname, nickname.isEmpty {
                        contents.removeAll()
                    }
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



#Preview {
    ProfileView()
    //KeywordSettingView()
}


