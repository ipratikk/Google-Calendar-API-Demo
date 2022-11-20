//
//  LoginView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {

    @EnvironmentObject var loginViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            LottieView(name: "calendar_home", loopMode: .loop)
            Spacer()
            GoogleSignInButton(action: loginViewModel.signIn)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
