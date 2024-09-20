//
//  BulletinBoardView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI
import UIKit
import FirebaseFirestore

struct BulletinBoardView: View {
    @State private var search = ""
    @State private var contents: [String: Api.BBoardData] = [:]
    @FocusState private var isTextFieldFocused: Bool
    @State private var showCancelButton = false
    @State private var showTip = false
    @State private var userWidth: CGFloat = 0   //작성자 텍스트의 width
    @State private var searchFilter: SearchFilter = .detail
    @State private var showFullScreen = false
    
    @State private var showCancelAlert = false
    @State private var showRegisterAlert = false

    @State private var isLoading = true
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(spacing: 0) {
                HStack {
                    ZStack(alignment: .trailing) {
                        TextField("", text: $search, prompt: Text("검색어 입력").foregroundColor(Color(.systemGray3)))
                            .padding(.leading)
                            .foregroundColor(.black)
                            .accentColor(.pink)
                            .frame(height: 30)
                            .background(.white)
                            .cornerRadius(30)
                            .focused($isTextFieldFocused)
                        
                        if search.isEmpty {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.pink)
                                .padding(.trailing)
                        } 
                        else {
                            Image(systemName: "x.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.pink)
                                .padding(.trailing)
                                .onTapGesture {
                                    search = ""
                                }
                        }
                    }
                    .padding(isTextFieldFocused ? .leading : .horizontal)
                    
                    if showCancelButton {
                        Button {
                            search = ""
                            withAnimation{
                                isTextFieldFocused = false
                            }
                        } label: {
                            Text("취소")
                                .foregroundColor(.pink)
                                .padding([.trailing])
                        }
                        .transition(.move(edge: .trailing))
                    }
                }
                .animation(.easeInOut, value: isTextFieldFocused)
                
                ScrollView {
                    LazyVStack {
                        HStack {
                            Spacer()
                            Text("글")
                                .frame(width: userWidth)
                                .font(.system(size: 17, weight: searchFilter == .detail ? .bold : .regular))
                                .onTapGesture {
                                    searchFilter = .detail
                                }
                                .foregroundColor(searchFilter == .detail ? .pink : .black)
                            Spacer()
                            Text("제목")
                                .frame(width: userWidth)
                                .font(.system(size: 17, weight: searchFilter == .title ? .bold : .regular))
                                .foregroundColor(searchFilter == .title ? .pink : .black)
                                .onTapGesture {
                                    searchFilter = .title
                                }
                            Spacer()
                            Text("작성자")
                                .background(GeometryReader { geo in
                                    Color.clear.onAppear {
                                        userWidth = geo.size.width
                                    }
                                })
                                .font(.system(size: 17, weight: searchFilter == .nickname ? .bold : .regular))
                                .foregroundColor(searchFilter == .nickname ? .pink : .black)
                                .onTapGesture {
                                    searchFilter = .nickname
                                }
                            Spacer()
                        }
                        .padding(.top)
                        
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
                            .frame(minHeight: UIScreen.main.bounds.height * 0.6)
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
                                    if search.isEmpty || (selectFilter(for: content, filter: searchFilter) ?? "").contains(search) {
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
                                        }
                                    }
                                }
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear{
                Task{
                    repeat {
                        if let data = await api.fetchData(for: ["Content": "bboard", "all": "_"]){
                            contents = data.compactMapValues { value in
                                value.first?.bboardData
                            }
                        }
                    }
                    while contents.isEmpty
                    isLoading = false
                }
            }
            .overlay{
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 40, weight: .heavy))
                            .foregroundColor(.pink)
                            .padding()
                            .onTapGesture {
                                showFullScreen = true
                            }
                    }
                }
            }
            .fullScreenCover(isPresented: $showFullScreen) {
                RegisterFullScreenView(isLoading: $isLoading)
            }
            .onChange(of: showFullScreen) { newValue in
                if !newValue {
                    Task{
                        contents.removeAll()
                        isLoading = true
                        try? await Task.sleep(nanoseconds: 1_000_000_000) // 딜레이가 꼭 있어야 함
                        repeat {
                            if let data = await api.fetchData(for: ["Content": "bboard", "all": "_"]){
                                contents = data.compactMapValues { value in
                                    value.first?.bboardData
                                }
                            }
                        }
                        while contents.isEmpty
                        isLoading = false
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: isTextFieldFocused) { focused in
            withAnimation {
                showCancelButton = focused
            }
        }
    }
    private enum SearchFilter {
        case title, detail, nickname
    }
    
    private func selectFilter(for data: Api.BBoardData, filter: SearchFilter) -> String? {
        if filter == .detail {
            return data.content
        }
        if filter == .title {
            return data.title
        }
        if filter == .nickname {
            return data.nickname
        }
        return nil
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

struct RegisterFullScreenView: View {
    @Binding var isLoading: Bool
    @State private var showCancelAlert = false
    @State private var showRegisterAlert = false
    @State private var nickname = ""
    @State private var title = ""
    @State private var content = ""
    @State private var artist = ""
    @FocusState private var isFocusedOnTitleField: Bool
    @FocusState private var isFocusedOnArtistField: Bool
    @State private var isFocusedOnTextEditor = false
    @State private var textEditorHeight: CGFloat = 30
    @Environment(\.presentationMode) var presentationMode
    
    // 변수 정의
    @State private var kakaoUserId = UserDefaults.standard.string(forKey: "kakaoUserId")
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .onTapGesture {
                        showCancelAlert = true
                    }
                    .alert(isPresented: $showCancelAlert) {
                        Alert(
                            title: Text("게시글 취소"),
                            message: Text("작성을 취소하겠습니까?\n작성한 내용은 저장되지 않습니다"),
                            primaryButton: .destructive(Text("확인"), action: {
                                presentationMode.wrappedValue.dismiss()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                Spacer()
                Text("등록")
                    .bold()
                    .frame(width: 60, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.pink.opacity(0.5))
                    )
                    .foregroundColor(.pink)
                    .onTapGesture {
                        showRegisterAlert = true
                    }
                    .alert(isPresented: $showRegisterAlert) {
                        Alert(
                            title: Text("게시글 등록"),
                            message: Text("게시글을 등록하시겠습니까?"),
                            primaryButton: .default(Text("등록").foregroundColor(.pink), action: {
                                Task {
                                    do {
                                        let array = try await fetchArrayFromFirestore(forKey: "nickname")
                                        nickname = array.first ?? ""
                            
                                    } catch {
                                        print("데이터 가져오기 실패: \(error)")
                                    }
                                    
                                    let result = await api.fetchData(for: [
                                        "Content": "bboard",
                                        "write": "_",
                                        "nickname": nickname,
                                        "title": title,
                                        "content": content,
                                        "post_date": dateToString(Date(), format: "yyyy-MM-dd / HH:mm:ss"),
                                        "artist": artist
                                    ])
                                }
                                presentationMode.wrappedValue.dismiss()
                                isLoading = false
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
            }
            .padding([.horizontal, .bottom])
            
            ScrollView {
                LazyVStack {
                    TextField("", text: $title, prompt: Text("제목")
                        .foregroundColor(.gray)
                        .bold()
                    )
                    .lineLimit(1)
                    .padding(.vertical)
                    .foregroundColor(.black)
                    .accentColor(.pink)
                    .frame(height: 30)
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isFocusedOnTitleField = true
                        }
                    }
                    .focused($isFocusedOnTitleField)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray).opacity(0.5)
                    
                    TextField("", text: $artist, prompt: Text("아티스트")
                        .foregroundColor(.gray)
                        .bold()
                    )
                    .lineLimit(1)
                    .padding(.vertical)
                    .foregroundColor(.black)
                    .accentColor(.pink)
                    .frame(height: 30)
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isFocusedOnArtistField = true
                        }
                    }
                    .focused($isFocusedOnArtistField)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray).opacity(0.5)
                    
                    UIKitTextEditor(text: $content,
                                    isFocused: $isFocusedOnTextEditor,
                                    minHeight: $textEditorHeight
                    )
                    .frame(minHeight: textEditorHeight)
                }
            }
            .onTapGesture {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isFocusedOnTextEditor = true
                }
            }
            .padding(.horizontal)
        }
        .background(Color.p3LightGray)
    }
    
    private func dateToString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt.string(from: date)
    }
    
    private func fetchArrayFromFirestore(forKey key: String) async throws -> [String] {
        if kakaoUserId == nil {
            return [String]()
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
                
                // key에 해당하는 값을 먼저 배열로 시도하고, 배열이 아니면 문자열로 시도
                if let array = data?[key] as? [String] {
                    continuation.resume(returning: array)
                } else if let stringValue = data?[key] as? String {
                    // 문자열일 경우, 문자열을 배열에 담아 반환
                    continuation.resume(returning: [stringValue])
                } else {
                    // 값이 없거나 다른 타입일 경우 빈 배열 반환
                    continuation.resume(returning: [])
                }
            }
        }
    }
}




#Preview {
//    BulletinBoardView()
//    RegisterFullScreenView()
}
