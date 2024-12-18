//
//  LoginView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 13/7/24.
//

import SwiftUI

struct LoginView: View {
    private enum FocusedField {
        case username, password
    }
    @Environment(AuthViewModel.self) var authVM
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        @Bindable var viewModel = authVM
        VStack {
            VStack(spacing: 28) {
                Title()
                    .padding(.top, 44)
                VStack(spacing: 16) {
                    TextField("Username", text: $viewModel.usernameTMDB)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .capsuleModifier(focusedField == .username || viewModel.usernameTMDB != "" ? .white : .bw50, input: true)
                        .foregroundStyle(viewModel.usernameTMDB != "" ? .white : .bw50)
                        .focused($focusedField, equals: .username).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                    
                    SecureField("Password", text: $viewModel.passwordTMDB)
                        .capsuleModifier(focusedField == .password || viewModel.passwordTMDB != "" ? .white : .bw50, input: true)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password).animation(.easeInOut, value: focusedField)
                        .tint(.white)
                        .submitLabel(.go)
                        .onSubmit {
                            login()
                        }
                    
                    Button(action: {
                        login()
                    }, label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    })
                    .buttonStyle(.capsuleButton(.orangeGradient))
                    .disabled(viewModel.flow == .authenticating)
                    VStack {
                        Text("By clicking the login button, you accept Privacy")
                        Text("Policy rules of our company")
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14))
                    .foregroundStyle(.bw50)
                    .padding(.top, 2)
                    Spacer()
                    VStack {
                        Text("Don't have an account?")
                            .foregroundStyle(.bw50)
                            .font(.system(size: 16))
                        Link("Join TMDB", destination: URL(string: "https://www.themoviedb.org/signup")!)
                            .foregroundStyle(.blue1)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 27)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
    
    @ViewBuilder
    private func Title() -> some View {
        VStack {
            VStack(spacing: 36) {
                Text("Login")
                    .font(.system(size: 34))
                VStack(spacing: 12) {
                    Image("profileDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
//                    Text("Add your\navatar")
//                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 24)
            }
            .foregroundStyle(.white)
        }
    }
    
    private func login() {
        Task {
            do {
                try await authVM.loginTMDB()
            } catch {
                print("DEBUG - Error: Error in LoginView")
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    @Previewable @State var preview = AuthViewModel()
    preview.account?.id = 1
    preview.account?.name = "Name"
    preview.account?.username = "Username"
    return NavigationStack {
        LoginView()
            .environment(preview)
    }
})
