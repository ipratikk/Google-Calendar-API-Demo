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
            if loginViewModel.calendarListItems.count == 0 {
                Button(action: {
                    loginViewModel.signIn()
                }, label: {
                    Text("Retry")
                })
            }
            ForEach(loginViewModel.calendarListItems, id: \.identifier) { item in
                NavigationLink {
                    CalendarListEventView(calendarId: item.identifier!)
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

struct CalendarListView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarListView()
    }
}
