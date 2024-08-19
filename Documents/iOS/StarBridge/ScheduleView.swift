//
//  ScheduleView.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-07.
//

import Foundation
import UIKit
import SwiftUI

struct ScheduleView: View{
    // -- 달력 관련 변수들 ---
    private let today: Date = Date()
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    @State private var isExpanded: Bool = false     //  캘린더 확장 여부 변수
    @State private var selectDate: Date = Date()    //  캘린더에서 사용자가 선택하는 날짜
    @State private var showDate: Date = Date()      //  캘린더에서 현재 보여지고 있는 날짜
    @State private var maxEventsCountOnEachWeeks: [Date:Int] = [:]    // 그 주에 있는 가장 행사가 많은 날: 그 날의 행사 갯수
    @State private var noEventsComing = true        //  다가오는 스케줄 뷰에서 2주간 이벤트가 있는지 없는지 저장
    

    // --- api 관련 변수들 ---
    @State private var schedules: [String:[ResponseData]] = [:]
    
    // --- 기준이 되는 디바이스에 대한 비율 반환
    func stdRatio(_ geoProxy: GeometryProxy) -> CGFloat{
        return geoProxy.size.width / iPhonePointRes.iPhoneXSMax.width
    }

    var body: some View{
        GeometryReader{ geometry in
            ScrollView{
                VStack{
                    TextView("음악 방송, 예능, 앨범, 기념일까지 컴백 시즌 모드 일정 한 눈에", size: 15, color: Color.gray)
                    VStack{
                        LazyVStack(spacing: 10){
                            HStack(alignment: .bottom){
                                Text(showDate, formatter: DateFormatter.krFormatter)
                                    .font(.system(size: 30 * stdRatio(geometry), weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                                TextView("오늘", size: 17 * stdRatio(geometry), weight: .bold, color: .white)
                                    .frame(width: 60 * stdRatio(geometry), height: 40 * stdRatio(geometry))
                                    .background(isSameDay(date1: today, date2: showDate) &&
                                                isSameDay(date1: today, date2: selectDate) ? .p3SlateGray : .p3CharcoalBlue)
                                    .cornerRadius(5 * stdRatio(geometry))
                                    .onTapGesture {
                                        selectDate = today
                                        showDate = today
                                    }
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(width: 40 * stdRatio(geometry), height: 40 * stdRatio(geometry))
                                    .background(.p3CharcoalBlue)
                                    .cornerRadius(5 * stdRatio(geometry))
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
                                    .font(.system(size: 20 * stdRatio(geometry), weight: .medium))
                                    .frame(width: 40 * stdRatio(geometry), height: 40 * stdRatio(geometry))
                                    .background(.p3CharcoalBlue)
                                    .cornerRadius(5 * stdRatio(geometry))
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
                            
                            LazyVGrid(columns: columns) {
                                ForEach(calendarDates(date: selectDate), id: \.self) { date in
                                    LazyVStack(spacing: 0){
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
                                                    let events: [ResponseData] = schedules[dateToString(date)] ?? []
                                                        ForEach(events, id: \.self) { event in
                                                            if let singer = event.singer{
                                                                NavigationLink(destination: ScheduleDetailView(detail: event.detail ?? "")){
                                                                Text(singer)
                                                                    .font(.system(size: CGFloat(min(20, 50 / max(singer.count, 1)))))
                                                                    .foregroundColor(dotColor(event.kind))
                                                                    .lineLimit(1)
                                                                    .frame(width: 50, height: 20)
                                                                    .border(dotColor(event.kind))
                                                                    .navigationTitle("")
                                                                    
                                                            }
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
                                            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                                                    removal: .move(edge: .bottom).combined(with: .opacity)))
                                        }
                                    }
                                    .frame(width: 50)
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
                                }
                            }
                            
                        }
                    }
                    .onAppear{
                        Task{
                            if let data = await loadData(for: dateToString(showDate, format: "yyyy-MM")){
                                schedules = data
                            }
                        }
                    }
                    .onChange(of: showDate) { newDate in
                        Task{
                            if let data = await loadData(for: dateToString(newDate, format: "yyyy-MM")){
                                schedules = data
                            }
                        }
                    }
                    .background(.white)
                    .cornerRadius(30)
                    .padding()
                    
                    if !isExpanded{
                        Group{
                            HStack{ // 오늘 or 선택한 날에 있는 스케줄
                                TextView("\(selectDateDate)일 (\(selectDateDay))", size: 20, weight: .bold)
                                    .padding()
                                Spacer()
                            }
                            .frame(height: 25)
                            .padding(.horizontal)
                            
                            if let events: [ResponseData] = schedules[dateToString(selectDate)] {
                                LazyVStack{
                                    ForEach(events, id: \.self) { event in
                                        HStack{
                                            VStack(alignment: .leading){
                                                Text(event.title ?? "")
                                                    .lineLimit(2)
                                                Text(event.x_id ?? "")
                                            }
                                            .foregroundStyle(Color.black)
                                            .padding(.horizontal)
                                            Spacer()
                                        }
                                        .frame(height: 100)
                                        .background(.white)
                                        .cornerRadius(15)
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
                                    .padding()
                                Spacer()
                            }
                            .frame(height: 25)
                            .padding(.horizontal)
                            
                            
                            let dates: [Date] = (1...14).compactMap { calendar.date(byAdding: .day, value: $0, to: selectDate) }
                            VStack{
                                ForEach(dates, id: \.self) { date in
                                    if let events: [ResponseData] = schedules[dateToString(date)] {
                                        ForEach(events, id: \.self) { event in
                                            HStack{
                                                VStack(alignment: .leading){
                                                    Text(event.title ?? "")
                                                        .lineLimit(2)
                                                    Text(event.x_id ?? "")
                                                    Text(event.event_date ?? "")
                                                }
                                                .foregroundStyle(Color.black)
                                                .padding(.horizontal)
                                                Spacer()
                                            }
                                            .frame(height: 100)
                                            .background(.white)
                                            .cornerRadius(15)
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
                .frame(width: geometry.size.width)
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
            return .red
        }
        return .clear
    }
    
    private func calendarDates(date: Date) -> [Date] {
        var dates: [Date] = []

        // 이번 달의 첫 번째 날짜와 마지막 날짜 계산
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: showDate)),
              let range = calendar.range(of: .day, in: .month, for: showDate) else { return dates }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        
        // 이전 달의 날짜들 계산
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth),
           let previousMonthRange = calendar.range(of: .day, in: .month, for: previousMonth) {
            let previousMonthDays = Array(previousMonthRange.suffix(firstWeekday))
            for day in previousMonthDays {
                dates.append(calendar.date(byAdding: .day, value: day - previousMonthRange.count - 1, to: firstDayOfMonth)!)
            }
        }

        // 이번 달의 날짜들 추가
        for day in range {
            dates.append(calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!)
        }

        // 다음 달의 날짜들 추가 (5행을 맞추기 위해)
        var remainingDays = 42 - dates.count
        if remainingDays >= 7 { remainingDays -= 7 }
        if remainingDays > 0, let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth){
            for day in 1...remainingDays {
                dates.append(calendar.date(byAdding: .day, value: day - 1, to: nextMonth)!)
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
    
    // --- api 관련 함수들 및 자료형 ---
    @MainActor
    @discardableResult
    func loadData(for date: String) async -> [String: [ResponseData]]? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_MAIN_URL") as? String else {
            fatalError("Wrong API key.")
        }
        
        guard let url = URL(string: apiKey) else {
            fatalError("Wrong URL.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["date": date]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([String: [ResponseData]].self, from: data)
                return decodedData
            } else {
                print("Failed to receive valid response.")
                await loadData(for: date)
                return nil
            }
            
        } catch {
            print("Failed to load data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadImage(from base64String: String) -> UIImage?{
        guard let imageData = Data(base64Encoded: base64String) else {
            print("Failed to decode base64 string.")
            return nil
        }
        return UIImage(data: imageData)
    }
    
    struct ResponseData: Codable, Hashable {    // 절대 바꾸지 말것
        let kind: String?
        let title: String?
        let detail: String?
        let singer: String?
        let x_id: String?
        let event_date: String?
        let post_date: String?
        let url: String?
        let photos: [String]?
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
