//
//  MediaTabs.swift
//  MovixApp
//
//  Created by Ancel Dev account on 25/7/24.
//

import SwiftUI

struct MediaTabs: View {
    var body: some View {
        ScrollView(.horizontal) {
//            GeneralInfo()
            MediaDetailsInfo()
        }
    }
}

#Preview {
    MediaTabs()
        .background(.bw20)
}
