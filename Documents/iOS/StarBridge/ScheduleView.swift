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
    
    @State private var isExpanded: Bool = false
    @State private var selectDate: Date = Date()
    @State private var showDate: Date = Date()
    
    
    // --- api 관련 변수들 ---
    @State private var schedules: [String:[ResponseData]] = [:]

    var body: some View{
        GeometryReader{ geometry in
            ScrollView{
                VStack{
                    TextView("음악 방송, 예능, 앨범, 기념일까지 컴백 시즌 모드 일정 한 눈에", size: 15, color: Color.gray)
                    VStack{
                        VStack(spacing: 10){
                            HStack(alignment: .bottom){
                                Text(showDate, formatter: DateFormatter.krFormatter)
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                                TextView("오늘", size: 17, weight: .bold, color: .white)
                                    .frame(width: 60, height: 40)
                                    .background(isSameDay(date1: today, date2: showDate) &&
                                                isSameDay(date1: today, date2: selectDate) ? .p3SlateGray : .p3CharcoalBlue)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        selectDate = today
                                        showDate = today
                                        
                                    }
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(width: 40, height: 40)
                                    .background(.p3CharcoalBlue)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if let nextMonthDate = calendar.date(byAdding: .month, value: -1, to: showDate){
                                            showDate = nextMonthDate
                                        }
                                        if let nextMonthDate = calendar.date(byAdding: .month, value: -1, to: selectDate){
                                            selectDate = nextMonthDate
                                        }
                                        
                                    }
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(width: 40, height: 40)
                                    .background(.p3CharcoalBlue)
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
                            
                            LazyVGrid(columns: columns) {
                                ForEach(calendarDates(date: selectDate), id: \.self) { date in
                                    VStack{
                                        TextView("\(calendar.component(.day, from: date))", weight: .medium, color: setDayforegroundColor(date: date))
                                            .frame(width: 30, height: 30)
                                            .background(setDayBackgroundColor(date: date))
                                            .cornerRadius(15)
                                            .padding(.bottom, 6)
//                                        
                                        if isExpanded{
                                            
                                        }
                                        else{
                                            HStack(spacing: 2){
                                                let events = schedules[dayMonthYear(date)]?.prefix(3) ?? []
                                                ForEach(events, id: \.self) { event in
                                                    Image(systemName: "circle.fill")
                                                        .font(.system(size: 4))
                                                        .foregroundColor(dotColor(event.kind))
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 50, height: isExpanded ? 50 : 40)
//                                    .border(Color.black)
                                    .onTapGesture {
                                        selectDate = date
                                        if calendar.component(.month, from: selectDate) != showMonth{
                                            showDate = date
                                        }
                                    }
                                }
                            }
                            .padding([.horizontal, .bottom])
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .foregroundColor(.black)
                                .padding()
                                .onTapGesture {
                                    isExpanded = !isExpanded
                                }
                            
                        }
                    }
//                    .frame(height: geometry.size.height / 2)
                    .onAppear{
                        Task{
                            await loadData(for: yearMonth(showDate))
                        }
                    }
                    .background(.white)
                    .cornerRadius(30)
                    .border(Color.black)
                    .padding()
                                    
                    HStack{ // 오늘 있는 스케줄
                        TextView("오늘의 스케줄", size: 20, weight: .bold)
                            .padding()
                        Spacer()
                    }
                    .frame(height: 25)
                    .padding(.horizontal)
                    
                    VStack{
                        
                    }
                    .frame(height: geometry.size.width / 3)
                    .background(.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
                    .border(.black)
                    
                    HStack{ //  그 주에 있는 스케줄
                        TextView("다가오는 스케줄", size: 20, weight: .bold)
                            .padding()
                        Spacer()
                        ZStack{
                            
                        }
                    }
                    .padding(.horizontal)
                
                    VStack{
                        
                    }
                    .frame(height: geometry.size.width / 3)
                    .background(.white)
                    .cornerRadius(30)
                    .padding(.horizontal)
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
    
    private var showYear: Int {
        calendar.component(.year, from: showDate)
    }
    
    private var showMonth: Int {
        calendar.component(.month, from: showDate)
    }
    
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    private func yearMonth(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM"
        return fmt.string(from: date)
    }
    
    private func dayMonthYear(_ date: Date) -> String{
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: date)
    }
  
    private func setDayforegroundColor(date: Date) -> Color {
        if isSameDay(date1: date, date2: today) || isSameDay(date1: date, date2: selectDate){
            return .white
        }
        else if showYear == calendar.component(.year, from: date) && showMonth == calendar.component(.month, from: date){
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
            return Color.brown
        case "축제":
            return Color.purple
        case "사진":
            return Color.cyan
        default:
            return Color.black
        }
    }

    
    // --- api 관련 함수들 및 자료형 ---
    func loadData(for date: String) async {
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    // JSON 데이터를 모델로 디코딩
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([String: [ResponseData]].self, from: data)
                    
                    DispatchQueue.main.async{
                        schedules = decodedData
                    }
                    
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    DispatchQueue.main.async {
//                        print(jsonString)
//                    }
//                }
            }
            else{
                print("Unable to get data")
            }
        }
        .resume()
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
