//
//  ProfileView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct ProfileView: View {
    let name: String
    let email: String
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 104, height: 104)
                    Text(name)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                    Text(email)
                        .font(.system(size: 16))
                        .foregroundStyle(.bw50)
                }
                .padding(.top, 20)
                VStack(alignment: .leading, spacing: 0) {
                    SettingsList()
                    Button(action: {
                        /// Logout action
                        print("Logout")
                    }, label: {
                        Text("Logout")
                            .foregroundStyle(.blue1)
                            .font(.system(size: 20))
                    })
                    .padding(.leading)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
}

#Preview {
    NavigationStack {
        ProfileView(name: "Anna", email: "catya80@gmail.com")
    }
}
