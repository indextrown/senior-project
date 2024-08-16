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
    // --- api 관련 변수들 ---
    private let api = apiMain()
    @State private var parsedData: [String: ResponseData]? = [:]
    
    // -- 달력 관련 변수들 ---
    private let today: Date = Date()
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    @State private var isExpanded: Bool = false
    @State private var selectDate: Date = Date()
    @State private var showDate: Date = Date()
    
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
                                        TextView("\(calendar.component(.day, from: date))", weight: .medium, color: setDayForegroundColor(date: date))
                                            .frame(width: 30, height: 30)
                                            .background(setDayBackgroundColor(date: date))
                                            .cornerRadius(15)
                                            .padding(.bottom, 6)
                                        
            //                            Image(systemName: "ellipsis")
            //                                .font(.system(size: 20))
            //                                .foregroundColor(.black)
                                        
//                                        ForEach()
                                        
                                    }
                                    .frame(width: 50, height: isExpanded ? 50 : 40)
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
//                        Spacer()
                    }
//                    .frame(height: geometry.size.height / 2)
                    .background(.white)
                    .cornerRadius(30)
                    .border(Color.black)
                    .onAppear{
                        parsedData = api.getData(for: "\(showYear)-\(showMonth)")
                    }
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
                        testView()
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
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
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
    
    private func setDayForegroundColor(date: Date) -> Color {
        if isSameDay(date1: date, date2: today) || isSameDay(date1: date, date2: selectDate){
            return .white
        }
        else if showYear == calendar.component(.year, from: date) && showMonth == calendar.component(.month, from: date){
            return .black
        }
        return .gray
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
    
    enum dotColor{
        case broad, festival, photo
        case null
        func color() -> Color {
            switch self {
            case .broad:
                return Color.brown
            case .festival:
                return Color.purple
            case .photo:
                return Color.cyan
            default:
                return Color.black
            }
        }
    }
}

extension DateFormatter {
    static let krFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월" // 한국어 형식의 연월 포맷
        return formatter
    }()
}

#Preview{
    ScheduleView()
}
