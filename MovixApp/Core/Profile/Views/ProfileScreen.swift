//
//  ProfileScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct ProfileScreen: View {
    
    @Environment(AuthViewModel.self) var authViewModel
    
    @State private var userVM = UserViewModel()
    
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    if authViewModel.account?.avatarPath == nil {
                        Image(.profileDefault)
                            .resizable()
                            .frame(width: 104, height: 104)
                    } else {
                        AsyncImage(url: URL(string: (authViewModel.account?.avatarPath)!)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .overlay {
                                        Circle()
                                            .stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                                    }
                            } else if phase.error != nil {
                                Text("No image available")
                            } else {
                                Image(systemName: "photo")
                            }
                        }
                        .frame(width: 104, height: 104)
                    }
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
                        .environment(userVM)
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
        ProfileScreen()
            .environment(AuthViewModel())
    }
}
