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
    @Binding var itemsView: ViewOption
    
    var body: some View {
        HStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
                    .padding(.leading, 12)
                    .padding(.trailing, 4)
                TextField("Search...", text: $searchTerm, prompt: Text("Search...").foregroundStyle(.bw50))
                    .tint(Color.bw90)
                
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
            .padding(.leading, 16)
            //            .padding(.horizontal)
            HStack(spacing: 8) {
                Button(action: {
                    filterAction()
                }, label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.white)
                })
                Button(action: {
                    withAnimation(.easeInOut) {
                        itemsView = itemsView == .row ? .grid : .row
                    }
                }, label: {
                    Image(systemName: itemsView == .row ? "rectangle.grid.3x2" : "rectangle.grid.1x2")
                        .foregroundStyle(.white)
                })
            }
            .frame(height: 42)
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    SearchBar(searchTerm: .constant(""), filterAction: {}, itemsView: .constant(.row))
        .background(.bw20)
})
