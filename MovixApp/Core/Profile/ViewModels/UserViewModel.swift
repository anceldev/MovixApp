//
//  UserViewModel.swift
//  MovixApp
//
//  Created by Ancel Dev account on 27/1/25.
//

import Foundation
import Observation

@Observable
final class UserViewModel {
    var language: String = "en-US"
    
    
    private var preferredCountry = Country()
    private var countries = [Country]()
    
    private let httpClient = HTTPClient()
    
    init() {
        Task {
            await getCountries()
            setPreferredCountry()
            await getLanguages()
        }
    }
    
    private func setPreferredCountry() {
        if self.countries.isEmpty { return }
        let locale = Locale.current.region?.identifier
        let localeCountry = self.countries.first { $0.iso31661 == locale }
        guard let countryExists = localeCountry else { return }
        self.preferredCountry = countryExists
        print("Preferred Country: \(countryExists.englishName)")
        
        // -7.5681183495200735, -51.95129393735624 Brazil locaiton
    }
    
    
    private func getCountries() async {
        let resource = Resource(
            url: URL(string: "https://api.themoviedb.org/3/configuration/countries")!,
            method: .get([URLQueryItem(name: "language", value: "en-US")]),
            modelType: [Country].self
        )
        do {
            let countries = try await httpClient.load(resource)
            self.countries = countries
        } catch {
            print(error.localizedDescription)
        }
    }
    private func getLanguages() async {
        let resource = Resource(
            url: URL(string: "https://api.themoviedb.org/3/configuration/primary_translations")!,
            modelType: [String].self
        )
        do {
            let languages = try await httpClient.load(resource)
            if languages.count == 0 {
                return
            }
            let language = languages.first { locale in
                let components = locale.split(separator: "-")
                return components.count == 2 && components[1] == self.preferredCountry.iso31661
            }
            guard let selectedLanguage = language else { return }
            
            print(selectedLanguage)
            self.language = selectedLanguage
            print("lan in viewmodel: ", self.language)
        } catch {
            print(error.localizedDescription)
        }
    }
}
