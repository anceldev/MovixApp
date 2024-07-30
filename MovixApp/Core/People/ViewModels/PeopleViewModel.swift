//
//  PeopleViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 30/7/24.
//

import Foundation

@Observable
class PeopleViewModel {
    var actor: People? = nil
    
    init(id: Int) {
        getPeople(id)
    }
    
    func getPeople(_ id: Int) {
        Task {
            do {
                self.actor = try await ApiTMDB.shared.getPeople(id: id)
            } catch {
                print("DEBUG - Error: ApiTMDB error")
            }
        }
    }

}
