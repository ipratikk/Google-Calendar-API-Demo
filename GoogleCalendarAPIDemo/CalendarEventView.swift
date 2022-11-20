//
//  CalendarEventView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import GoogleAPIClientForREST_Calendar

struct CalendarEventView: View {
    @EnvironmentObject var loginViewModel: AuthenticationViewModel
    var event: GTLRCalendar_Event
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.summary ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .cornerRadius(5)
            Text(getStartEndTime(event))
                .font(.caption)
            if event.hangoutLink != nil {
                Text(event.hangoutLink!)
                    .font(.caption)
            }
        }
        .lineLimit(1)
        .padding()
        .background(getColor(event))
        .cornerRadius(5)
    }

    func getColor(_ item: GTLRCalendar_Event) -> Color {
        guard let colorID = item.colorId,
              let colorID = Int(colorID),
              let colorDefinition = loginViewModel.calendarColorDefinitions?.event[colorID]
        else {
            return Color(hex: "#039be5")
        }
        let background = Color(hex: colorDefinition.background)
        return background
    }

    func getStartEndTime(_ item: GTLRCalendar_Event) -> String {
        let start = item.start
        let end = item.end
        let startTime = dateToString(start?.dateTime?.date ?? Date.now)
        let endTime = dateToString(end?.dateTime?.date ?? Date.now)
        return "\(startTime) - \(endTime)"
    }

    func dateToString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        let day = df.string(from: date)
        return day
    }

}
