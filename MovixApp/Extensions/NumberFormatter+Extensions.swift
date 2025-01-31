//
//  PopularityFormatter.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation

extension NumberFormatter {
    static var popularity: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
