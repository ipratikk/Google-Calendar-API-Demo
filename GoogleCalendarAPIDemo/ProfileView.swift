//
//  ProfileView.swift
//  GoogleCalendarAPIDemo
//
//  Created by Goel, Pratik on 20/11/22.
//

import SwiftUI
import GoogleSignIn

struct ProfileView: View {

    @EnvironmentObject var loginViewModel: AuthenticationViewModel

    private let user = GIDSignIn.sharedInstance.currentUser

    var body: some View {
        VStack {
            HStack {
                NetworkImage(url: user?.profile?.imageURL(withDimension: 200))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100, alignment: .center)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(user?.profile?.name ?? "")
                        .font(.headline)

                    Text(user?.profile?.email ?? "")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding()

            Spacer()

            Button(action: loginViewModel.signOut) {
                Text("Sign out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemIndigo))
                    .cornerRadius(12)
                    .padding()
            }
        }
    }
}

    /// A generic view that shows images from the network.
struct NetworkImage: View {
    let url: URL?

    var body: some View {
        // To be refactored to use URLSession
        if let url = url,
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
