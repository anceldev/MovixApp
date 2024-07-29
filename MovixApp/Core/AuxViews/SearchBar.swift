//
//  SearchBar.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchTerm: String
    var filterAction: () -> Void
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
                    .padding(.leading, 12)
                    .padding(.trailing, 4)
                TextField("Search", text: $searchTerm)
                    .foregroundStyle(.white)
                
                Button(action: {
                    searchTerm = ""
                }, label: {
                    Label("Clear", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.bw50)
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(.bw40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            Button(action: {
                filterAction()
            }, label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.white)
            })
            .frame(width: 62, height: 42)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}
  
#Preview(traits: .sizeThatFitsLayout, body: {
    SearchBar(searchTerm: .constant(""), filterAction: {})
        .background(.bw20)
})
