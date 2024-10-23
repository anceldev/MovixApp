//
//  ProfileView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(AuthViewModel.self) var authViewModel
    
    var body: some View {
        VStack {
            Text("Account")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .fontWeight(.semibold)
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 104, height: 104)
                    Text(authViewModel.account?.name ?? "No name")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                    Text(authViewModel.account?.username ?? "No username")
                        .font(.system(size: 16))
                        .foregroundStyle(.bw50)
                }
                .padding(.top, 20)
                VStack(alignment: .leading, spacing: 0) {
                    SettingsList()
                    Button(action: {
                        print("Logout")
                        logout()
                    }, label: {
                        Text("Logout")
                            .foregroundStyle(.blue1)
                            .font(.system(size: 20))
                    })
                    .padding(.leading)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
    private func logout() {
        Task {
            do {
                try await authViewModel.logoutTMDB()
                
            } catch {
                print("DEBUG - Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environment(AuthViewModel())
//            .environmentObject(AuthenticationViewModel())
    }
}
