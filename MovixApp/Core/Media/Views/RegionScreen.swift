//
//  RegionScreen.swift
//  MovixApp
//
//  Created by Ancel Dev account on 3/2/25.
//

import SwiftUI

struct RegionScreen: View {
    @Environment(UserViewModel.self) var userVM
    
    @State private var selectedTranslation: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {

            Text("Availble translations")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
            VStack {
                ScrollView(.vertical) {
                    ForEach(userVM.translations, id: \.self) { translation in
                        Button {
                            self.selectedTranslation = translation
                        } label: {
                            HStack {
                                Text(userVM.languageCountryLabel(code: translation) ?? "NO - Language")
                                    .tag(translation)
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                Spacer()
                                if selectedTranslation == translation {
                                    Image(systemName: "checkmark.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, .marsB)
                                        .font(.system(size: 20))
                                    
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.bottom, 24)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)

        .onChange(of: selectedTranslation) {
            print(selectedTranslation)
        }
        .swipeToDismiss()
    }
}
#Preview {
    RegionScreen()
        .environment(UserViewModel())
}
