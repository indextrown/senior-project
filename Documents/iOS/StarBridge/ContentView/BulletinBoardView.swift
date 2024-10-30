//
//  BulletinBoardView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI
import UIKit


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
        ScrollViewReader{ scrollProxy in
            VStack(spacing: 0) {
                HStack {
                    ZStack(alignment: .trailing) {
                        TextField("", text: $search, prompt: Text("검색어 입력").foregroundColor(Color(.systemGray3)))
                            .padding(.leading)
                            .foregroundColor(.black)
                            .accentColor(.pink)
                            .frame(height: 30)
                            .background(.white)
                            .cornerRadius(15)
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
                        .id("bulletinBoardList")
                        
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
                                                            //글쓴 날짜가 오늘과 같다면 쓴 시간만 표시하고 반대면 날짜만
                                                            Text(showDate(date: content.post_date))
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
                                    }
                                }
                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
            .background(.p3LightGray)
            .onAppear{
                Task{
                    var count = 0
                    while contents.isEmpty && count < 3 {
                        if let data = await api.fetchData(for: ["Content": "bboard", "all": "_"]){
                            contents = data.compactMapValues { value in
                                value.first?.bboardData
                            }
                        }
                        count += 1
                    }
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
                        isLoading = true
                        contents.removeAll()
                        var count = 0
                        try? await Task.sleep(nanoseconds: 2_000_000_000) // 딜레이가 꼭 있어야 함
                        while contents.isEmpty && count < 3 {
                            if let data = await api.fetchData(for: ["Content": "bboard", "all": "_"]){
                                contents = data.compactMapValues { value in
                                    value.first?.bboardData
                                }
                            }
                            count += 1
                        }
                        isLoading = false
                    }
                    scrollProxy.scrollTo("bulletinBoardList", anchor: .top)
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

struct BulletinBoardDetailView: View {
    var detail: Api.BBoardData
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                            Text(detail.artist ?? "")
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                                
                        }
                            .foregroundColor(.pink)
                        Text(detail.title ?? "")
                            .font(.system(size: 20, weight: .semibold))
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .padding()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)
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
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)
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
                                    
                                    let _ = await api.fetchData(for: [ //   나중에는 반환값 받아서 쿼리문이 제대로 실행되었는지 안되었는지 확인할 예정
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
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 1)
                    
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
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 1)
                    
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
}




#Preview {
    BulletinBoardView()
//    RegisterFullScreenView()
}
