//
//  GoogleCalendarAPIDemoApp.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import Firebase

@main
struct GoogleCalendarAPIDemoApp: App {

    @StateObject var loginViewModel = AuthenticationViewModel()

    init() {
        setupAuthentication()
    }

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

extension GoogleCalendarAPIDemoApp {
    private func setupAuthentication() {
        FirebaseApp.configure()
    }
}
