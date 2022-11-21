//
//  CalendarEventList.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import GoogleSignIn

struct CalendarEventList: View {
    @EnvironmentObject var loginViewModel: AuthenticationViewModel
    @AppStorage("defaultCalendar") var calendarId: String = "primary"
    @State var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading) {
            CustomTimePicker(selectedYear: $selectedYear, selectedMonth: $selectedMonth)
            CalendarEventListItems(events: loginViewModel.allEvents[getCalendarId()] ?? [], month: selectedMonth, year: selectedYear)
        }
        .navigationTitle("Events")
    }

    func getCalendarId() -> String {
        var calendarID = self.calendarId
        let user = GIDSignIn.sharedInstance.currentUser
        if user?.profile?.email == calendarID {
            calendarID = "primary"
        }
        return calendarID
    }
}
