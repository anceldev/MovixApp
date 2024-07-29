//
//  TestMovie.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import SwiftUI

struct TestMovie: View {
    let title: String
    let overview: String
    var body: some View {
        VStack {
            Text(title)
            Text(overview)
        }
    }
}

#Preview {
    TestMovie(title: "Title", overview: "overview")
}
