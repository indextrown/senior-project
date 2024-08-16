import SwiftUI

struct testView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    
    private var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }
    
    private var daysInMonth: [Date] {
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }
    
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols
    }
    
    var body: some View {
        VStack {
            // Header: Year and Month
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentDate, formatter: DateFormatter.krFormatter)
                    .font(.headline)
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Days of the week
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 5)
            
            // Days grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth, id: \.self) { date in
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.body)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(8)
                        .background(isSameDay(date1: date, date2: selectedDate) ? Color.blue : Color.clear)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
            Spacer()
        }
        .padding()
    }
    
    // Functions for navigating months
    private func previousMonth() {
        currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate)!
    }
    
    private func nextMonth() {
        currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
    }
    
    // Helper function to compare days
    private func isSameDay(date1: Date, date2: Date?) -> Bool {
        guard let date2 = date2 else { return false }
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}



#Preview{
    testView()
}
