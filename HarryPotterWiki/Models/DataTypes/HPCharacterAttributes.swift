//
//  HPCharacterAttributes.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 20.12.2024.
//

import Foundation

struct HPCharacterAttributes: Codable {
    let animagus: String?
    let bloodStatus: String? // blood_status
    let boggart: String?
    let born: String?
    let died: String?
    let familyMembers: [String] // family_member
    let gender: String?
    let hairColor: String? // hair_color
    let height: String?
    let house: String?
    let image: String?
    let jobs: [String]
    let name: String
    let patronus: String?
    let romances: [String]
    let species: String?
    let wands: [String]
    let slug: String
    
    private enum CodingKeys: String, CodingKey {
        case bloodStatus = "blood_status"
        case familyMembers = "family_members"
        case hairColor = "hair_color"
        case animagus, boggart, born, died, gender, height, house, image, jobs, name, patronus, romances, species, wands, slug
    }
}

extension HPCharacterAttributes {
    var isKeyCharacter: Bool {
        HPKeyCharacters.names.contains(slug)
    }
    
    var additionalInfo: [String] {
        let familyMembers = familyMembers.joined(separator: ", ")
        let romances = romances.joined(separator: ", ")
        let wands = wands.joined(separator: ", ")
        let jobs = jobs.joined(separator: ", ")
        let info = [
            "Animagus: \(animagus ?? "No")",
            "Blood status: \(bloodStatus ?? "Unknown")",
            "Boggart: \(boggart ?? "Unknown")",
            "Family members: \(familyMembers.isEmpty ? "Unknown": familyMembers)",
            "Hair color: \(hairColor ?? "Unknown")",
            "Height: \(height ?? "Unknown")",
            "Jobs: \(jobs.isEmpty ? "Unknown": jobs)",
            "Patronus: \(patronus ?? "Unknown")",
            "Romances: \(romances.isEmpty ? "Unknown": romances)",
            "Species: \(species ?? "Unknown")",
            "Wands: \(wands.isEmpty ? "Unknown": wands)",
        ]
        return info
    }
}
