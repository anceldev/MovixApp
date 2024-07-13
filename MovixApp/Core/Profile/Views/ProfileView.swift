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
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
        
        
    }
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    Image("profileDefault")
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
                    Text("Account settings")
                        .font(.system(size: 22))

                    VStack {
                            NavigationLink {
                                Text("Personal Details")
                            } label: {
                                HStack {
                                    Label("Personal Details", systemImage: "square.and.pencil")
                                    Spacer(minLength: 0)
                                    
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)
                            }
                            .listRowBackground(Color.bw20)
                        
                            NavigationLink {
                                Text("Friends")
                            } label: {
                                Label("Friends", systemImage: "person.2")
                            }
                            .listRowBackground(Color.bw20)
                            NavigationLink {
                                Text("Notifications")
                            } label: {
                                Label("Notifications", systemImage: "bell")
                            }
                            .listRowBackground(Color.bw20)
                            NavigationLink {
                                Text("Recomendations")
                            } label: {
                                Label("Recomendations", systemImage: "heart")
                            }
                            .listRowBackground(Color.bw20)
                            NavigationLink {
                                Text("History")
                            } label: {
                                Label("History", systemImage: "clock.arrow.circlepath")
                            }
                            .listRowBackground(Color.bw20)
                    }
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity)
                    .background(.bw20)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .foregroundStyle(.white)
            }
        }
        .background(.bw10)
    }
}

#Preview {
//    NavigationStack {
        ProfileView(name: "Anna", email: "catya80@gmail.com")
//    }
}
