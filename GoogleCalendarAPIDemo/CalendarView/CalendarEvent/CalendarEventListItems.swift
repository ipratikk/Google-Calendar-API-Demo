//
//  CalendarEventListItems.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 21/11/22.
//

import SwiftUI
import GoogleAPIClientForREST_Calendar

struct CalendarEventListItems: View {
    private let calendar = Calendar.current
    var events: [GTLRCalendar_Event]
    var month: Int
    var year: Int

    var body: some View {
        ZStack {
            if filteredEventsByMonth().count == 0 {
                GeometryReader { proxy in
                    LottieView(name: "noData", loopMode: .loop)
                        .frame(width: proxy.size.width / 2, height: proxy.size.height / 2, alignment: .center)
                        .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                }
            }
            List {
                ForEach(1 ... getRange(year: year, month: month) , id: \.self) { day in
                    if let filteredData = filteredEvents(day), filteredData.count > 0 {
                        Section(header: Text("\(calendar.monthSymbols[month-1]) \(day)")) {
                            ForEach(filteredData, id: \.identifier) { event in
                                CalendarEventView(event: event)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }

    func filteredEventsByMonth() -> [GTLRCalendar_Event] {
        let filterByYear = events.filter({
            calendar.component(.year, from: $0.created?.date ?? Date.now) == year
        })
        let filterByMonth = filterByYear.filter({
            calendar.component(.month, from: $0.created?.date ?? Date.now) == month
        })
        return filterByMonth
    }

    func filteredEvents(_ day: Int) -> [GTLRCalendar_Event] {
        let filterByMonth = filteredEventsByMonth()
        let filterByDay = filterByMonth.filter({
            calendar.component(.day, from: $0.created?.date ?? Date.now) == day
        })
        return filterByDay
    }

    func getRange(year: Int, month: Int) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: DateComponents(year: year, month: month + 1))!)!.count
    }
}
