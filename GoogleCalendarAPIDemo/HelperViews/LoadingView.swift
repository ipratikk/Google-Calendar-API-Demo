//
//  LoadingView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    var loopMode: LottieLoopMode = .playOnce
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            LottieView(name: "loader", loopMode: loopMode)
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
