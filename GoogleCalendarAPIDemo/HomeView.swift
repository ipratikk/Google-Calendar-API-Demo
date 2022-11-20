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
            CalendarListEventView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
