//
//  People.swift
//  MovixApp
//
//  Created by Ancel Dev account on 29/7/24.
//

import Foundation


/// 10859
///

struct People: Identifiable, Decodable {
    let id: Int
    let name: String
    let biography: String?
    let birthday: Date?
    let gender: Gender?
    let homepage: URL?
    let popularity: Double?
    let profilePath: URL?
    
    var age: Int? {
        let calendar = Calendar.current
        if self.birthday != nil {
            let yearComponent = calendar.dateComponents([.year], from: self.birthday!, to: .now)
            return yearComponent.year
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case birthday
        case gender
        case homepage
        case popularity
        case profilePath = "profile_path"
    }
    
    enum Gender: String {
        case ns = "No specified"
        case female = "Female"
        case male = "Male"
        case nb = "Non binary"
    }
    
    init(id: Int, name: String, biography: String?, birthday: Date?, gender: Gender?, homepage: URL?, popularity: Double?, profilePath: URL?) {
        self.id = id
        self.name = name
        self.biography = biography
        self.birthday = birthday
        self.gender = gender
        self.homepage = homepage
        self.popularity = popularity
        self.profilePath = profilePath
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        
        self.biography = try values.decodeIfPresent(String.self, forKey: .biography)
        
        if let birthOn = try values.decodeIfPresent(String.self, forKey: .birthday) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birthday = dateFormatter.date(from: birthOn)
        } else {
            self.birthday = nil
        }
        
        if let genderP = try values.decodeIfPresent(Int.self, forKey: .gender) {
            switch genderP {
            case 2: self.gender = .female
            case 3: self.gender = .male
            case 4: self.gender = .nb
            default:
                self.gender = .ns
            }
        } else {
            self.gender = .ns
        }
        self.homepage = try values.decodeIfPresent(URL.self, forKey: .homepage)
        self.popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        let profile = try values.decodeIfPresent(String.self, forKey: .profilePath)
        self.profilePath = URL(string: "https://image.tmdb.org/t/p/original\(profile ?? "")")
    
    }
    
}

extension People {
    static var preview: People = .init(
        id: 10859,
        name: "Ryan Reynolds",
        biography: "Ryan Rodney Reynolds (born October 23, 1976) is a Canadian actor and film producer. He began his career starring in the Canadian teen soap opera Hillside (1991–1993), and had minor roles before landing the lead role on the sitcom Two Guys and a Girl between 1998 and 2001. Reynolds then starred in a range of films, including comedies such as National Lampoon's Van Wilder (2002), Waiting... (2005), and The Proposal (2009). He also performed in dramatic roles in Buried (2010), Woman in Gold (2015), and Life (2017), starred in action films such as Blade: Trinity (2004), Green Lantern (2011), 6 Underground (2019) and Free Guy (2021), and provided voice acting in the animated features The Croods (2013), Turbo (2013), Pokémon: Detective Pikachu (2019) and The Croods: A New Age (2020).\n\nReynolds' biggest commercial success came with the superhero films Deadpool (2016) and Deadpool 2 (2018), in which he played the title character. The former set numerous records at the time of its release for an R-rated comedy and his performance earned him nominations at the Critics' Choice Movie Awards and the Golden Globe Awards.",
        birthday: .now,
        gender: .male,
        homepage: nil,
        popularity:  172.40,
        profilePath: URL(string: "https://image.tmdb.org/t/p/w185/2Orm6l3z3zukF1q0AgIOUqvwLeB.jpg")
    )
}
