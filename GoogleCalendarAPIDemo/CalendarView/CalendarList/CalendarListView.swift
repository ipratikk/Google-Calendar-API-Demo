//
//  CalendarListView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI

struct CalendarListView: View {
    @EnvironmentObject var loginViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 15) {
            ForEach(loginViewModel.calendarListItems, id: \.identifier) { item in
                NavigationLink {
                    CalendarEventList(calendarId: item.identifier!)
                }label: {
                    CalendarListItemView(calendarItem: item)
                        .cornerRadius(15)
                }
            }
            .listStyle(SidebarListStyle())
        }
        .padding()
    }
}
