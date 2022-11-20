//
//  ContentView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var loginViewModel: AuthenticationViewModel

    var body: some View {
        switch loginViewModel.state {
        case .signedIn:
            Text("Logged In")
        case .signedOut: LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
