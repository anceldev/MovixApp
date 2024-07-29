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
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
