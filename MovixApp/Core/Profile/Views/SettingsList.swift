//
//  SettingsList.swift
//  MovixApp
//
//  Created by Ancel Dev account on 19/7/24.
//

import SwiftUI

struct SettingsList: View {
    let pv: CGFloat = 0.0
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Text("Account Settings")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                VStack(spacing: 16) {
                    NavigationLink {
                        Text("Personal Details")
                    } label: {
                        HStack {
                            Label("Personal Details", systemImage: "square.and.pencil")
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.top, 6)
                    NavigationLink {
                        Text("Friends")
                    } label: {
                        HStack {
                            Label("Friends", systemImage: "person.2")
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                        }
                    }
                    NavigationLink {
                        Text("Notifications")
                    } label: {
                        HStack {
                            Label("Notifications", systemImage: "bell")
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                        }
                    }
                    NavigationLink {
                        Text("Recomendations")
                    } label: {
                        HStack {
                            Label("Recomendations", systemImage: "heart")
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .padding(16)
                .background(Color.bw20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            VStack(spacing: 12) {
                Text("More info & Support")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
        
                VStack(spacing: 16) {
                    NavigationLink {
                        SupportScreen()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Label("Support", systemImage: "lifepreserver")
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.top, 6)
                    
                    NavigationLink {
                        AboutScreen()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Label("About", systemImage: "info.circle")
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .padding(16)
                .background(Color.bw20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .font(.system(size: 16))
        .foregroundStyle(.white)
        .padding()
        
    }
}
