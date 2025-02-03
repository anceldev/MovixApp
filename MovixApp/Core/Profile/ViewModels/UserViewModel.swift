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
    
    var countries = [Country]()
    var languages: [Language] = []
    var translations: [String] = []
    
    var errorMessage: String?
    
    private let httpClient = HTTPClient()
    
    init() {
        Task {
            await getCountries()
            setPreferredCountry()
            await getTranslations()
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
    
    func getLanguages() async {
        let resource = Resource(
            url: Endpoints.languages.url,
            modelType: [Language].self
        )
        do {
            let languages = try await httpClient.load(resource)
            self.languages = languages
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func languageCountryLabel(code: String) -> String? {
        let language = self.languages.first { $0.iso3691 == code.prefix(2) }
        let country = self.countries.first { $0.iso31661 == code.suffix(2) }
        if let language, let country {
            return "\(language.englishName.capitalized) - \(country.englishName.uppercased())"
        }
        return nil
    }
    
    private func getTranslations() async {
        let resource = Resource(
            url: URL(string: "https://api.themoviedb.org/3/configuration/primary_translations")!,
            modelType: [String].self
        )
        do {
            let translations = try await httpClient.load(resource)
            self.translations = translations
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
//    func filterTranslations(withLang: String) -> [String]{
//        if self.translations.isEmpty { return self.translations }
//        return self.translations.filter { $0.starts(with: withLang) }
//    }
}
