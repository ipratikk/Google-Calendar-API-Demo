//
//  CalendarListItemView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import UIKit
import GoogleAPIClientForREST_Calendar

struct CalendarListItemView: View {
    var calendarItem: GTLRCalendar_CalendarListEntry

    var body: some View {
        VStack {
            HStack {
                Text(calendarItem.summary ?? "")
                Spacer()
                if calendarItem.primary == 1 {
                    VStack(alignment: .trailing) {
                        Text("Primary")
                            .padding([.leading,.trailing], 4)
                            .padding([.top,.bottom], 2)
                            .font(.footnote)
                            .background(.gray)
                            .foregroundColor(.black)
                            .cornerRadius(5)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: calendarItem.backgroundColor ?? "#fffff"))
        .foregroundColor(Color(hex: calendarItem.foregroundColor ?? "#00000"))
    }
}
