//
//  FiltersView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct FiltersView: View {
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                print("Apply...")
            }, label: {
                Text("Apply")
            })
            .buttonStyle(.capsuleButton(.lightGray))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#1F1F1F").opacity(0.75))
//        .onAppear(perform: {
//            showGenres()
//        })
    }
//    private func showGenres() {
//        for genre in Genres.combinedGenres {
//            print(genre.name)
//        }
//    }
}

#Preview {
    FiltersView()
}
