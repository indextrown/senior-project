//
//  BulletinBoardView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI


struct BulletinBoardView: View {
    @State private var recentSearch:[String] = []
    @State private var search = ""
    @State private var contents: [String: Api.BBoardData] = [:]
    @FocusState private var isfocusedTextField: Bool
    @State private var showCancelButton = false
    @State private var showTip = false
    @State private var userWidth: CGFloat = 0   //작성자 텍스트의 width
    @State private var searchFilter: SearchFilter = .detail
    @State private var showSheet = false
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                HStack {
                    ZStack(alignment: .trailing) {
                        TextField("", text: $search, prompt: Text("검색어 입력").foregroundColor(Color(.systemGray3)))
                            .padding(.leading)
                            .foregroundColor(.black)
                            .accentColor(.pink)
                            .frame(height: 30)
                            .background(.white)
                            .cornerRadius(30)
                            .focused($isfocusedTextField)
                        
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
                    .padding(isfocusedTextField ? .leading : .horizontal)
                    
                    if showCancelButton {
                        Button {
                            search = ""
                            withAnimation{
                                isfocusedTextField = false
                            }
                        } label: {
                            Text("취소")
                                .foregroundColor(.pink)
                                .padding([.trailing])
                        }
                        .transition(.move(edge: .trailing))
                    }
                }
                .animation(.easeInOut, value: isfocusedTextField)
                
                ScrollView {
                    LazyVStack {
                        HStack {
                            Spacer()
                            Text("글")
                                .frame(width: userWidth)
                                .font(.system(size: 17, weight: searchFilter == .detail ? .bold : .regular))
                                .foregroundColor(searchFilter == .detail ? .pink : .black)
                                .onTapGesture {
                                    searchFilter = .detail
                                    print("detail")
                                }
                            Spacer()
                            Text("제목")
                                .frame(width: userWidth)
                                .font(.system(size: 17, weight: searchFilter == .title ? .bold : .regular))
                                .foregroundColor(searchFilter == .title ? .pink : .black)
                                .onTapGesture {
                                    searchFilter = .title
                                    print("title")
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
                                    print("nickname")
                                }
                            Spacer()
                        }

                        ForEach(contents.keys
                            .sorted()
                            .compactMap { contents[$0] } , id: \.self) { content in
                                if search.isEmpty || (selectFilter(for: content, filter: searchFilter) ?? "").contains(search) {
                                    VStack{
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
                    .padding([.horizontal, .bottom])
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear{
                Task{
                    if let data = await api.fetchData(for: ["Content": "bboard", "all": "_"]){
                        contents = data.compactMapValues { value in
                            value.first?.bboardData
                        }
                    }
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
                                showSheet = true
                            }
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
//                ScrollView {
                    VStack {
                        Spacer()
                        Text("close this sheetView")
                            .onTapGesture {
                                showSheet = false
                            }
                        Spacer()
                    }
//                }
                .frame(width: geometry.size.width)
                .background(.p3LightGray)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: isfocusedTextField) { focused in
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


#Preview {
    BulletinBoardView()
}
