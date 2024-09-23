//
//  CafeView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-23.
//

import SwiftUI

struct CafeView: View {
    @State private var cafeList: [String:[Api.CafeData]] = [:]
    @State private var isLoading = true
    @State private var celebrities: [String] = []
    @State private var filterList: [String] = []
    @State private var filterWordSize: CGFloat = .zero
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showStartDatePicker: Bool = false
    @State private var showEndDatePicker: Bool = false
    @State private var showSearchSheet: Bool = false
    
    @State private var showCelebrity = ""

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                                .onTapGesture {
                                    showSearchSheet = true
                                }
                                .fullScreenCover(isPresented: $showSearchSheet) {
                                    SearchFullScreenView(
                                        celebrities: celebrities,
                                        filterList: $filterList,
                                        showCelebrity: $showCelebrity
                                    )
                                }

                            if isLoading {
                                Spacer()
                            } 
                            else {
                                if filterList.isEmpty {
                                    Spacer()
                                    Text("연예인를 터치해주세요")
                                        .foregroundColor(.gray)
                                        .padding(.trailing)
                                } 
                                else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 10) {
                                            ForEach(filterList.reversed(), id: \.self) { celebrity in
                                                Text(celebrity)
                                                    .foregroundColor(.black)
                                                    .onTapGesture {
                                                        filterList.removeAll { $0 == celebrity }
                                                    }
                                                    .scaleEffect(x: -1)
                                            }
                                        }
                                    }
                                    .scaleEffect(x: -1)
                                }
                            }
                        }
                        .frame(height: 50)
                        Rectangle()
                            .frame(width: .infinity, height: 1)
                            .border(Color.gray.opacity(0.4))
                        HStack {
                            HStack {
                                Text("날짜")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(dateFormatter.string(from: startDate))
                                    .foregroundColor(.black)
                                    .frame(width: 100)
                                    .onTapGesture {
                                        showStartDatePicker.toggle()
                                    }
                                Text("~")
                                    .foregroundColor(.black)
                                Text(dateFormatter.string(from: endDate))
                                    .foregroundColor(.black)
                                    .frame(width: 100)
                                    .onTapGesture {
                                        showEndDatePicker.toggle()
                                    }
                            }
                            .onChange(of: startDate) { newStartDate in
                                if newStartDate >= endDate {
                                    startDate = endDate
                                }
                            }
                            .onChange(of: endDate) { newEndDate in
                                if newEndDate <= startDate {
                                    endDate = startDate
                                }
                            }
                            Spacer()
                        }
                        .frame(height: 50)
                    }
                    .padding(.horizontal)
                    .background(.white)
                    .cornerRadius(15)
                    .padding([.horizontal, .bottom])
                    
                    if isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .scaleEffect(1.5)
                            Text("생일카페 데이터를 불러오는 중...")
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                            Spacer()
                        }
                    }
                    else {
                        ScrollView {
                            LazyVStack {
                                ForEach(
                                    cafeList.values
                                    .flatMap { $0 }
                                    .sorted {
                                        let firstCelebrity = $0.celebrity ?? ""
                                        let secondCelebrity = $1.celebrity ?? ""

                                        if firstCelebrity != secondCelebrity {
                                            return firstCelebrity < secondCelebrity
                                        }
                                        return firstCelebrity.count < secondCelebrity.count
                                        }, id: \.self) { cafe in

                                    if (filterList.isEmpty || !filterList.filter({ cafe.celebrity?.contains($0) ?? false }).isEmpty) &&
                                        (isSameDay(date1: startDate, date2: Date()) || startDate <= stringToDate(string: cafe.start_date ?? "")! && stringToDate(string: cafe.end_date ?? "")! <= endDate) {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Group {
                                                    HStack {
                                                        Image(systemName: "person.2")
                                                            .frame(width: 17, height: 17)
                                                            .foregroundColor(.pink)
                                                        Text(cafe.celebrity ?? "")
                                                            .bold()
                                                            .lineLimit(1)
                                                    }
                                                    HStack {
                                                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                                            .frame(width: 17, height: 17)
                                                            .foregroundColor(.yellow)
                                                        Text("\(cafe.start_date ?? "") ~ \(cafe.end_date ?? "")")
                                                            .font(.system(size: 15))
                                                    }
                                                    HStack {
                                                        Image(systemName: "house")
                                                            .frame(width: 17, height: 17)
                                                            .foregroundColor(.purple)
                                                        Text(cafe.place ?? "")
                                                            .font(.system(size: 15))
                                                            .lineLimit(1)
                                                    }
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
                                
                            }
                        }
                    }
                }
                
                if showStartDatePicker || showEndDatePicker {
                    Color.black.opacity(0.3)
                        .onTapGesture {
                            showStartDatePicker = false
                            showEndDatePicker = false
                        }
                        .ignoresSafeArea()
                    
                    HalfSheet(isPresented: $showStartDatePicker) {
                        VStack {
                            if showStartDatePicker {
                                DatePicker(
                                    "시작날짜",
                                    selection: $startDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(WheelDatePickerStyle())
                                .colorInvert()
                                .colorMultiply(.black)
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                            }
                            if showEndDatePicker {
                                DatePicker(
                                    "종료날짜",
                                    selection: $endDate,
                                    displayedComponents: [.date]
                                )
                                .datePickerStyle(WheelDatePickerStyle())
                                .colorInvert()
                                .colorMultiply(.black)
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                            }

                            HStack {
                                Spacer()
                                Button("완료") {
                                    showStartDatePicker = false
                                    showEndDatePicker = false
                                }
                                .font(.system(size: 16, weight: .bold))
                                .padding()
                            }
                        }
                        .padding()
                    }
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                }
            }
            .frame(width: geometry.size.width)
            .background(.p3LightGray)
            .onAppear {
                Task {
                    repeat {
                        if let cafeData = await api.fetchData(for: ["Content": "cafe", "all": "_"]) {
                            cafeList = cafeData.mapValues { values in
                                values.compactMap {$0.cafeData}
                            }
                        }
                    }
                    while cafeList.isEmpty
                    
                    celebrities = Array(cafeList.keys)
                    isLoading = false
                }
            }
        }
    }
    
    private func stringToDate(string dateString: String) -> Date? {
        let dmt = DateFormatter()
        dmt.dateFormat = "yyyy-MM-dd"
        dmt.locale = Locale(identifier: "en_US_POSIX")
        return dmt.date(from: dateString)
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct SearchFullScreenView: View {
    let celebrities: [String]
    @Binding var filterList: [String]
    @Binding var showCelebrity: String
    
    @State private var showAlert = false
    @State private var search = ""
    @State private var showCancelButton = false
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("", text: $search, prompt: Text("검색어 입력").foregroundColor(Color(.systemGray3)))
                        .padding(.leading)
                        .foregroundColor(.black)
                        .accentColor(.pink)
                        .frame(height: 30)
                        .background(.white)
                        .cornerRadius(15)
                        .textInputAutocapitalization(.never)
                        .focused($isTextFieldFocused)
                    
                    if search.isEmpty {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.pink)
                            .padding(.trailing)
                    } else {
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
                        withAnimation {
                            isTextFieldFocused = false
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("취소")
                            .foregroundColor(.pink)
                            .padding([.trailing])
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isTextFieldFocused = true
                }
            }
            .animation(.easeInOut, value: isTextFieldFocused)
            .padding(.vertical)
            
            ScrollView {
                LazyVStack {
                    ForEach(celebrities.filter {$0.contains(search)}.sorted(), id: \.self) { celebrity in
                        HStack {
                            Text(celebrity)
                                .bold(filterList.contains(celebrity))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .frame(height: 25)
                        .onTapGesture {
                            if filterList.contains(celebrity) {
                                filterList.removeAll {$0 == celebrity}
                            } else {
                                filterList.append(celebrity)
                            }
                            showAlert = true
                            showCelebrity = celebrity
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text(filterList.contains(showCelebrity) ? "필터링 추가" : "필터링 삭제" ),
                                message: Text("\(showCelebrity) 필터링 \(filterList.contains(showCelebrity) ? "추가" : "삭제")"),
                                dismissButton: .default(Text("확인"))
                            )
                        }
                        Rectangle()
                            .border(Color.p3LightGray)
                            .frame(width: .infinity, height: 1)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
        .background(Color.p3LightGray)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: isTextFieldFocused) { focused in
            withAnimation {
                showCancelButton = focused
            }
        }
    }
}

func sendNotification(detail body: String) {
    // 알림 콘텐츠 생성
    let content = UNMutableNotificationContent()
    content.title = "StarBridge"
    content.body = "키워드: \(body)"
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
