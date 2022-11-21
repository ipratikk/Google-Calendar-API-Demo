//
//  HomeView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import GoogleSignIn

struct HomeView: View {

    @EnvironmentObject var loginViewModel: AuthenticationViewModel
    private let user = GIDSignIn.sharedInstance.currentUser

    var body: some View {
        NavigationView {
            VStack {
                ScrollView{
                    CalendarListView()
                }
                .frame(maxWidth: .infinity)
                .overlay(content: {
                    if loginViewModel.calendarListItems.count == 0 {
                        LottieView(name: "noData", loopMode: .loop)
                    }
                })
            }
            .navigationTitle("Calendars")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                NavigationLink {
                    ProfileView()
                } label: {
                    NetworkImage(url: user?.profile?.imageURL(withDimension: 100))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                        .cornerRadius(25)
                }
            }
            CalendarEventList()
        }
    }
}
