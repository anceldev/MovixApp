//
//  PeopleViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation
import Observation


@Observable
final class CastViewModel {
    var cast: [Cast] = []
    
    
    init(id: Int?) {
        if(id != nil) {
            getCast(id: id!)
        }
    }
    
    func getCast(id: Int) {
        Task {
            do {
                self.cast = try await ApiTMDB.shared.getCasting(id: id)
            } catch {
                print("DEBUG - Error: ApiTMDB error \(error.localizedDescription)")
            }
        }
    }
}
