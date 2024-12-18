//
//  TabModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 1/8/24.
//

import Foundation
import SwiftUI

enum Tab {
    case home
    case search
    case favourites
    case profile
    
    var selected: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .favourites: return "heart.fill"
        case .profile: return "person.fill"
        }
    }
    var unselected: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .favourites: return "heart"
        case .profile: return "person"
        }
    }
}
