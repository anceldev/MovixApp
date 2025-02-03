//
//  TestingView.swift
//  MovixApp
//
//  Created by Ancel Dev account on 21/8/24.
//

import SwiftUI

// MARK: Building Custom View like ForEach
struct CompositionalView<Content, Item, ID>: View where Content: View, ID: Hashable,Item: RandomAccessCollection,Item.Element: Hashable{
    var content: (Item.Element) -> Content
    var items: Item
    var id: KeyPath<Item.Element,ID>
    var spacing: CGFloat
    init(items: Item,id: KeyPath<Item.Element, ID>, spacing: CGFloat = 8,@ViewBuilder content: @escaping (Item.Element) -> Content) {
        self.content = content
        self.id = id
        self.items = items
        self.spacing = spacing
    }
    
    var body: some View {
        LazyVStack(spacing: spacing){
            ForEach(generateColumns(), id: \.self) { row in
                RowView(row: row)
            }
        }
    }
    
    // MARK: Identifying Row Type
    func layoutType(row: [Item.Element]) -> LayoutType{
        let index = generateColumns().firstIndex { item in
            return item == row
        } ?? 0
        
        // MARK: Layout Order will be 1,2,3,1,2,3....
        var types: [LayoutType] = []
        generateColumns().forEach { _ in
            if types.isEmpty{
                types.append(.type1)
            }else if types.last == .type1{
                types.append(.type2)
            }else if types.last == .type2{
                types.append(.type3)
            }else if types.last == .type3{
                types.append(.type4)
            }else if types.last == .type4{
                types.append(.type1)
            }else{}
        }
        
        return types[index]
    }
    
    // MARK: Row View
    @ViewBuilder
    func RowView(row: [Item.Element]) -> some View{
        var heightRow: CGFloat {
            switch layoutType(row: row) {
            case .type1, .type3: 125
            case .type2: 50
            case .type4: 100
            }
        }
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = (proxy.size.height - spacing) / 2
            let type = layoutType(row: row)
            let columnWidth = (width > 0 ? ((width - (spacing * 2)) / 3) : 0)
            
            HStack(spacing: spacing) {
                // MARK: This Order is Your Wish
                if type == .type1 {
                    HStack(spacing: spacing) {
                        SafeView(row: row, index: 0)
                        VStack(spacing: spacing){
                            SafeView(row: row, index: 1)
                            SafeView(row: row, index: 2)
                        }
                        .frame(width: (width / 2))
                    }
                }
                if type == .type2 {
                    HStack(spacing: spacing) {
                        SafeView(row: row, index: 2)
                            .frame(width: columnWidth)
                        SafeView(row: row, index: 1)
                            .frame(width: columnWidth)
                        SafeView(row: row, index: 0)
                            .frame(width: columnWidth)
                    }
                }
                if type == .type3 {
                    VStack(spacing: spacing) {
                        SafeView(row: row, index: 0)
                            .frame(height: height)
                        SafeView(row: row, index: 1)
                            .frame(height: height)
                    }
                    .frame(width: (width / 2))
                    SafeView(row: row, index: 2)
                }
                if type == .type4 {
                    VStack(spacing: spacing) {
                        SafeView(row: row, index: 0)
                        HStack(spacing: spacing) {
                            SafeView(row: row, index: 1)
                                .frame(width: (width * 0.4) - (spacing / 2))
                            SafeView(row: row, index: 2)
                                .frame(width: ((width * 0.6) - (spacing / 2)))
                        }
                    }
                }
            }
        }
//        .frame(height: layoutType(row: row) == .type1 || layoutType(row: row) == .type3 || layoutType(row: row) == .type4 ? 125 : 50)
        .frame(height: heightRow)
//        .background(.green)
    }
    
    // MARK: Safely Unwrapping Content Index
    @ViewBuilder
    func SafeView(row: [Item.Element],index: Int) -> some View{
        if (row.count - 1) >= index{
            content(row[index])
        }
    }
    
    // MARK: Constructing Custom Rows And Columns
    func generateColumns()->[[Item.Element]]{
        var columns: [[Item.Element]] = []
        var row: [Item.Element] = []
        
        for item in items{
            // MARK: Each Row Consists of 3 Views
            // Optional You can Modify
            if row.count == 3{
                columns.append(row)
                row.removeAll()
                row.append(item)
            }else{
                row.append(item)
            }
        }
        
        // MARK: Adding Exhaust Ones
        columns.append(row)
        row.removeAll()
        return columns
    }
}

enum LayoutType{
    case type1
    case type2
    case type3
    case type4
}

struct TestingView: View {
    
    @State var selectedGenre: Int = 0
    
    var body: some View {
        ScrollView{
//            CompositionalView(items: Genres.combinedGenres, id: \.id) { item in
//                
//                Image(item.urlBackground!)
//                    .resizable()
//                    .overlay {
//                        Text(item.name)
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundStyle(.white)
//                            .shadow(color: .black, radius: 1)
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//            }
//            .padding()
//            .padding(.bottom,10)
        }
    }
}

#Preview {
    TestingView()
}
