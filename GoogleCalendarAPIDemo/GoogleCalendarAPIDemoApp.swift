//
//  GoogleCalendarAPIDemoApp.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI

@main
struct GoogleCalendarAPIDemoApp: App {

    @StateObject var loginViewModel = AuthenticationViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .onAppear {
                    loginViewModel.restoreSignIn()
                    loginViewModel.fetchData()
                }
        }
    }
}
