//
//  AuthenticateTMDB.swift
//  MovixApp
//
//  Created by Ancel Dev account on 31/7/24.
//

import SwiftUI

struct AuthenticateTMDB: View {
    @State var viewModel = AuthViewModel()
    @State var showAlert = false
    var body: some View {
        if viewModel.account == nil {
            VStack {
                TextField("username", text: $viewModel.usernameTMDB)
                SecureField("password", text: $viewModel.passwordTMDB)
                Button("Login") {
                    login()
                }
            }
            .alert("Failed TMDB Login", isPresented: $showAlert) {
                Button("OK") {
                    print("Ok")
                }
                .buttonStyle(.borderedProminent)
            } message: {
                Text("Failed trying to acces tmdb login account")
            }
        } else {
            Text("Hello \(viewModel.account?.name ?? viewModel.usernameTMDB)")
            Button("Logout", role: .cancel) {
                logout()
            }
        }

    }
    private func login() {
        Task {
            do {
                try await viewModel.loginTMDB()
            } catch {
                showAlert.toggle()
            }
        }
    }
    private func logout() {
        Task {
            do {
                try await viewModel.logoutTMDB()
            } catch {
                print("Error in logout: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    AuthenticateTMDB()
}
