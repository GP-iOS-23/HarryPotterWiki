//
//  HPCharacterFilter.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 13.01.2025.
//

import Foundation

protocol HPFilterOption {
    var title: String { get }
}

enum HPCharacterFilterType {
    case isKeyCharacter
    case house
    case bloodStatus
    
    var displayName: String {
        switch self {
        case .isKeyCharacter:
            return "Key Characters"
        case .house: 
            return "House"
        case .bloodStatus: 
            return "Blood Status"
        }
    }
}

enum House: String, HPFilterOption, CaseIterable {
    case gryffindor = "Gryffindor"
    case slytherin = "Slytherin"
    case hufflepuff = "Hufflepuff"
    case ravenclaw = "Ravenclaw"
    
    var title: String { rawValue }
}

enum BloodStatus: String, HPFilterOption, CaseIterable {
    case pureBlood = "Pure-blood"
    case halfBlood = "Half-blood"
    case muggleBorn = "Muggleborn"
    
    var title: String { rawValue }
}

enum HPCharacterFilterOption: HPFilterOption, Equatable {
    case isKeyCharacter
    case house(House)
    case bloodStatus(BloodStatus)
    
    var title: String {
        switch self {
        case .isKeyCharacter:
            return "Key Characters"
        case .house(let house):
            return house.rawValue
        case .bloodStatus(let bloodStatus):
            return bloodStatus.rawValue
        }
    }
}

struct HPCharacterFilter: Equatable {
    let type: HPCharacterFilterType
    let options: [HPCharacterFilterOption]
    var isSelected: Bool = false
    var selectedValue: HPCharacterFilterOption? = nil
    
    static func == (lhs: HPCharacterFilter, rhs: HPCharacterFilter) -> Bool {
        lhs.type == rhs.type
    }
}
