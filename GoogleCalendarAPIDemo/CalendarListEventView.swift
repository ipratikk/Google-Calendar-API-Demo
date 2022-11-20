//
//  CalendarListEventView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import GoogleAPIClientForREST_Calendar

struct CalendarListEventView: View {
    @AppStorage("defaultCalendar") var calendarId: String = "primary"
    @EnvironmentObject var loginViewModel: AuthenticationViewModel
    @State var calendarListEvents: [Date: [GTLRCalendar_Event]] = [:]
    @State var calendarListEventDates: [Dictionary<Date, [GTLRCalendar_Event]>.Keys.Element] = []
    @State var showLoading: Bool = true
    @State var showError: Bool = false

    var body: some View {
        ZStack {
            showLoader()
            List(calendarListEventDates, id: \.self) { item in
                HStack(alignment: .top) {
                    VStack {
                        Text(dateToString(item))
                            .frame(width:50)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                        .frame(width: 20)
                    VStack(alignment: .leading, spacing: 10){
                        ForEach(calendarListEvents[item]!, id: \.identifier) { event in
                            CalendarEventView(event: event)
                        }
                    }
                }
                .padding([.top,.bottom], 20)
                .cornerRadius(10)
            }
            .listStyle(PlainListStyle())
            .refreshable{
                getCalendarEvents()
            }
            .clipped()
            .task {
                getCalendarEvents()
            }
        }
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
    }

    func getCalendarEvents() {
        loginViewModel.getEvents(for: calendarId) { result in
            self.showLoading = false
            switch result {
            case .success((let events, let eventKeys)):
                self.calendarListEvents = events
                self.calendarListEventDates = eventKeys
            case .failure(_):
                self.showError = true
            }
        }
    }

    @ViewBuilder
    func showLoader() -> some View {
        if(self.showLoading == true){
            LoadingView(loopMode: .loop)
        }
    }

    func dateToString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM\nd"
        let day = df.string(from: date)
        return day
    }
}
