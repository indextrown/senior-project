//
//  ScheduleView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-07.
//

import UIKit
import SwiftUI

struct ScheduleView: View{
    // -- 달력 관련 변수들 ---
    private let today: Date = Date()
    
    //  캘린더 확장 여부 변수
    @State private var isExpanded: Bool = false
    //  캘린더에서 사용자가 선택하는 날짜
    @State private var selectDate: Date = Date()
    //  캘린더에서 현재 보여지고 있는 날짜
    @State private var showDate: Date = Date()
    //  그 주에 있는 가장 행사가 많은 날: 그 날의 행사 갯수
    @State private var maxEventsCountOnEachWeeks: [Date:Int] = [:]
    //  다가오는 스케줄 뷰에서 2주간 이벤트가 있는지 없는지 저장
    @State private var noEventsComing = true
    //  api로 받아오는 데이터 저장 (형태: "\(이벤트 날짜)": 데이터 배열)
    //  Api.SnsData는 api.swift 참고
    @State private var schedules: [String:[Api.SnsData]] = [:]
    @State private var calendarDefaultHeight: CGFloat = 10
    @State private var isLoading = true

    var body: some View{
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack {
                    VStack(spacing: 10){
                        HStack {
                            Text(showDate, formatter: DateFormatter.krFormatter)
                                .font(.system(size: 28 , weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                            TextView("오늘", size: 17, weight: .bold, color: .white)
                                .frame(width: 60 , height: 40 )
                                .background(isSameDay(date1: today, date2: showDate) &&
                                            isSameDay(date1: today, date2: selectDate) ? .pink.opacity(0.7) : .pink)
                                .cornerRadius(5)
                                .onTapGesture {
                                    selectDate = today
                                    showDate = today
                                }
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium))
                                .frame(width: 40 , height: 40 )
                                .background(.pink)
                                .cornerRadius(5)
                                .onTapGesture {
                                    if let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: showDate){
                                        showDate = prevMonthDate
                                    }
                                    if let prevMonthDate = calendar.date(byAdding: .month, value: -1, to: selectDate){
                                        selectDate = prevMonthDate
                                    }
                                }
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 20 , weight: .medium))
                                .frame(width: 40 , height: 40 )
                                .background(.pink)
                                .cornerRadius(5)
                                .onTapGesture {
                                    if let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: showDate){
                                        showDate = nextMonthDate
                                    }
                                    if let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: selectDate){
                                        selectDate = nextMonthDate
                                    }
                                    
                                }
                        }
                        .padding([.horizontal, .top])
                        
                        HStack {    //  요일 표시부분
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal)
                        
                        LazyVStack {
                            ForEach(calendarDates(date: selectDate), id: \.self) { week in
                                HStack(spacing: 0) {
                                    ForEach(week, id: \.self) { date in
                                        VStack(spacing: 2){
                                            TextView("\(calendar.component(.day, from: date))", weight: .medium, color: setDayforegroundColor(date: date))
                                                .frame(width: 30, height: 30)
                                                .background(setDayBackgroundColor(date: date))
                                                .cornerRadius(15)
                                                .padding(.bottom, 0)
                                                .onTapGesture {
                                                    selectDate = date
                                                    if calendar.component(.month, from: selectDate) != showDateMonth{
                                                        showDate = date
                                                    }
                                                }
                                            
                                            if isExpanded{
                                                let maxEventCountOnWeek: CGFloat = getMaxEventCountOnWeek(date: date)
                                                VStack(spacing: 2){
                                                    let events: [Api.SnsData] = schedules[dateToString(date)] ?? []
                                                    ForEach(events, id: \.self) { event in
                                                        if let artist = event.artist{
                                                            NavigationLink(destination: ScheduleDetailView(detail: event)){
                                                                Text(artist)
                                                                    .font(.system(size: CGFloat(min(20, 50 / max(artist.count, 1)))))
                                                                    .foregroundColor(dotColor(event.kind))
                                                                    .lineLimit(1)
                                                                    .frame(width: 50, height: 20)
                                                                    .border(dotColor(event.kind))
                                                            }
                                                            .navigationTitle("")
                                                        }
                                                    }
                                                    if events.count < Int(maxEventCountOnWeek){
                                                        Spacer()
                                                    }
                                                }
                                                .frame(height: max(22 * maxEventCountOnWeek - 2, 8))
                                                .transition(.opacity)
                                            }
                                            else{
                                                HStack(spacing: 1){
                                                    if let events = schedules[dateToString(date)]?.prefix(3){
                                                        ForEach(events, id: \.self) { event in
                                                            Image(systemName: "circle.fill")
                                                                .font(.system(size: 5))
                                                                .foregroundColor(dotColor(event.kind))
                                                        }
                                                    }
                                                    else{
                                                        Spacer()
                                                    }
                                                }
                                                .frame(height: 8)
                                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                            }
                                        }
                                        .frame(width: 50)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .onChange(of: schedules){ newSchedules in
                            for (dateString, events) in newSchedules{
                                if let newDate = stringToDate(string: dateString){
                                    maxEventsCountOnEachWeeks[newDate] = events.count
                                }
                            }
                        }
                        
                        HStack{
                            Spacer()
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .frame(height: 30)
                        .padding([.horizontal,.bottom])
                        .background(.white)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)){
                                isExpanded.toggle()
                                scrollProxy.scrollTo("calendar", anchor: .top)
                            }
                        }
                    }
                    .onAppear{
                        Task{
                            var count = 0
                            while schedules.isEmpty && count < 3 {
                                let dates = calendarDates(date: Date())
                                if let data = await api.fetchData(for: ["Content": "x",
                                                                        "startDate": dateToString(dates.first!.first!),
                                                                        "endDate": dateToString(dates.last!.last!)
                                                                       ]) {
                                    schedules = data.mapValues { values in
                                        values.compactMap {$0.snsData}
                                    }
                                }
                                count += 1
                            }
                            isLoading = false
                        }
                    }
                    .onChange(of: showDate) { newDate in
                        Task{
                            isLoading = true
                            var count = 0
                            while schedules.isEmpty && count < 3 {
                                let dates = calendarDates(date: newDate)
                                if let data = await api.fetchData(for: ["Content": "x",
                                                                        "startDate": dateToString(dates.first!.first!),
                                                                        "endDate": dateToString(dates.last!.last!)
                                                                       ]) {
                                    schedules = data.mapValues { values in
                                        values.compactMap {$0.snsData}
                                    }
                                }
                                count += 1
                            }
                            isLoading = false
                        }
                    }
                    .background(.white)
                    .cornerRadius(30)
                    .padding([.horizontal, .bottom])
                    .id("calendar")
                    
                    if isLoading {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                .scaleEffect(1.5)
                            Text("게시판 데이터를 불러오는 중...")
                                .foregroundColor(.gray)
                                .padding(.top, 20)
                        }
                        .frame(minHeight: UIScreen.main.bounds.height * 0.3)
                    }
                    else {
                        if !isExpanded{
                            Group{
                                HStack{ // 오늘 or 선택한 날에 있는 스케줄
                                    TextView("\(selectDateDate)일 (\(selectDateDay))", size: 20, weight: .bold)
                                        .padding(.vertical)
                                    Spacer()
                                }
                                .frame(height: 25)
                                .padding(.horizontal)
    
                                if let events: [Api.SnsData] = schedules[dateToString(selectDate)] {
                                    LazyVStack{
                                        ForEach(events, id: \.self) { event in
                                            NavigationLink(destination: ScheduleDetailView(detail: event)){
                                                HStack{
                                                    VStack(alignment: .leading){
                                                        Text(event.title ?? "")
                                                            .lineLimit(2)
                                                            .multilineTextAlignment(.leading)
                                                    }
                                                    .foregroundStyle(Color.black)
                                                    Spacer()
                                                }
                                                .padding(.horizontal)
                                                .frame(height: 100)
                                                .background(.white)
                                                .cornerRadius(15)
                                            }
                                            .navigationTitle("")
                                        }
                                    }
                                    .padding([.horizontal, .bottom])
    
                                }
                                else{
                                    VStack{
                                        Text("스케줄이 없어요")
                                            .font(.system(size: 17))
                                        Text("업데이트될 수 있으니 조금만 기다려주세요")
                                            .font(.system(size: 15))
                                    }
                                    .foregroundColor(.gray)
                                    .padding()
                                }
                            }
                            Group{
                                HStack{ //  selecteDate 기준으로 2주간의 이벤트
                                    TextView("다가오는 스케줄", size: 20, weight: .bold)
                                        .padding(.vertical)
                                    Spacer()
                                }
                                .frame(height: 25)
                                .padding(.horizontal)
    
    
                                let dates: [Date] = (1...14).compactMap { calendar.date(byAdding: .day, value: $0, to: selectDate) }
                                VStack{
                                    ForEach(dates, id: \.self) { date in
                                        if let events: [Api.SnsData] = schedules[dateToString(date)] {
                                            ForEach(events, id: \.self) { event in
                                                NavigationLink(destination: ScheduleDetailView(detail: event)){
                                                    HStack{
                                                        VStack(alignment: .leading){
                                                            Text(event.title ?? "")
                                                                .lineLimit(2)
                                                                .multilineTextAlignment(.leading)
                                                            Text(event.event_date ?? "")
                                                        }
                                                        .foregroundStyle(Color.black)
                                                        Spacer()
                                                    }
                                                    .padding(.horizontal)
                                                    .frame(height: 100)
                                                    .background(.white)
                                                    .cornerRadius(15)
                                                }
                                                .navigationTitle("")
                                            }
                                            .onAppear{
                                                noEventsComing = false
                                            }
                                            .onDisappear{
                                                noEventsComing = true
                                            }
                                        }
                                    }
                                }
                                .padding([.horizontal,.bottom])
    
                                if noEventsComing{
                                    VStack{
                                        Text("스케줄이 없어요")
                                            .font(.system(size: 17))
                                        Text("업데이트될 수 있으니 조금만 기다려주세요")
                                            .font(.system(size: 15))
                                    }
                                    .foregroundColor(.gray)
                                    .padding()
                                    .onAppear{
                                        noEventsComing = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .background(.p3LightGray)
        }
    }
    
    // --- 달력 관련 함수 및 확장 ---
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")   //  후에 타 언어 지원 시 case 문 추가
        return calendar
    }
    
    private var showDateYear: Int { //  년
        calendar.component(.year, from: showDate)
    }
    
    private var showDateMonth: Int {    // 월
        calendar.component(.month, from: showDate)
    }
    
    private var selectDateDate: Int {  // 일
        calendar.component(.day, from: selectDate)
    }
    
    private var selectDateDay: String{
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko_KR")
        fmt.dateFormat = "E"
        return fmt.string(from: selectDate)
    }
    
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    private func stringToDate(string dateString: String) -> Date? {
        let dmt = DateFormatter()
        // DateFormatter 설정
        dmt.dateFormat = "yyyy-MM-dd"
        dmt.locale = Locale(identifier: "en_US_POSIX") // 정확한 변환을 위해 Locale 설정
        
        return dmt.date(from: dateString)
    }
    
    func areDatesInSameWeek(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current

        // 각 날짜의 연도 및 주를 추출
        let weekOfYear1 = calendar.component(.weekOfYear, from: date1)
        let weekOfYear2 = calendar.component(.weekOfYear, from: date2)
        
        let year1 = calendar.component(.yearForWeekOfYear, from: date1)
        let year2 = calendar.component(.yearForWeekOfYear, from: date2)

        // 두 날짜의 주와 연도가 같으면 동일한 주에 속함
        return weekOfYear1 == weekOfYear2 && year1 == year2
    }

    
    private func getMaxEventCountOnWeek(date stdDate: Date) -> CGFloat {
        var count = 0
        for (date, eventcount) in maxEventsCountOnEachWeeks{
            if areDatesInSameWeek(date1: stdDate, date2: date){
                count = max(count, eventcount)
            }
        }
        return CGFloat(count)
    }
    
    private func dateToString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt.string(from: date)
    }
  
    private func setDayforegroundColor(date: Date) -> Color {
        if isSameDay(date1: date, date2: today) || isSameDay(date1: date, date2: selectDate){
            return .white
        }
        else if showDateYear == calendar.component(.year, from: date) && showDateMonth == calendar.component(.month, from: date){
            return .black
        }
        return .gray
    }
    
    private func setDayBackgroundColor(date: Date) -> Color {
        if isSameDay(date1: date, date2: selectDate){
            return .black
        }
        else if isSameDay(date1: date, date2: today){
            return .pink
        }
        return .clear
    }
    
    private func calendarDates(date: Date) -> [[Date]] {
        var dates: [[Date]] = []

        // 이번 달의 첫 번째 날짜와 마지막 날짜 계산
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let range = calendar.range(of: .day, in: .month, for: date) else { return dates }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        // 이전 달의 날짜들 계산
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth),
            let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth) {
            let previousMonthDays = Array(previousMonthRange.suffix(firstWeekday))
            var firstWeek: [Date] = []
            for day in previousMonthDays {
                firstWeek.append(calendar.date(byAdding: .day, value: day - previousMonthRange.count - 1, to: firstDayOfMonth)!)
            }
            
            if !firstWeek.isEmpty {
                dates.append(firstWeek)
            }
        }

        // 이번 달의 날짜들 추가
        for day in range {
            if dates.isEmpty || dates.last!.count == 7 { // 1일이 그 달의 첫번째 일요일일 때 or 그 주에 날짜가 더이상 들어갈 수 없을 때
                dates.append([Date]())
            }
            dates[dates.count - 1].append(calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!)
        }

        // 다음 달의 날짜들 추가 (5행을 맞추기 위해)
        var remainingDays = 42 - dates.flatMap { $0 } .count
        if remainingDays >= 7 { remainingDays -= 7 }
        if remainingDays > 0, let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth){
            for day in 1...remainingDays {
                if dates.last!.count == 7 {
                    dates.append([Date]())
                }
                dates[dates.count - 1].append(calendar.date(byAdding: .day, value: day - 1, to: nextMonth)!)
            }
        }

        return dates
    }
    
    private func dotColor(_ kind: String?) -> Color {
        switch kind {
        case "방송":
            return Color.indigo
        case "행사":
            return Color.purple
        case "사진":
            return Color.teal
        default:
            return Color.black
        }
    }
}

struct ScheduleDetailView: View {
    private var detail: Api.SnsData
    @State private var imageWidth = CGFloat.zero
    
    init(detail: Api.SnsData) {
        self.detail = detail
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.p3LightGray) // 원하는 배경색 설정
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(detail.title ?? "")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .lineLimit(3)
                    .padding(.top)
                
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 1)
                        .padding(.top)
                        .onAppear {
                            imageWidth = geometry.size.width
                        }
                }
                
                HStack {
                    VStack {
                        Group {
                            Text("날짜")
                            Text("채널")
                        }
                        .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading) {
                        Group {
                            Text(detail.event_date ?? "")
                            Text(detail.id ?? "")
                        }
                        .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.top)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(height: 1)
                    .padding(.top)
                
                Text(detail.detail ?? "")
                    .foregroundColor(.black)
                    .padding(.top)
                
                Text("👇 보러 가기")
                    .foregroundColor(.black)
                    .padding(.top)
                
                if let link = detail.url {
                    Link(destination: URL(string: link)!) {
                        Text(link)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                    }
                }
                
                if let images = detail.photos {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(images, id: \.self) { imageString in
                                if let image = api.loadImage(from: imageString) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: imageWidth)
                                }
                            }
                        }
                    }
                    .padding(.top)
                    .disabled(images.count == 1)
                }
            }
        }
        .padding(.horizontal)
        .background(.white)
        .navigationBarTitleDisplayMode(.inline) // inline 모드로 설정하여 툴바와 내용이 간격 없이 붙도록 함
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("스케줄")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
        }
    }
}

extension DateFormatter {
    static let krFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy년 M월" // 한국어 형식의 연월 포맷
        return fmt
    }()
}

#Preview{
    ScheduleView()
}
