//
//  HPCharacterMainInfoCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 29.12.2024.
//

import Foundation

final class HPCharacterCellViewModel {
    private let character: HPCharacter
    
    init(character: HPCharacter) {
        self.character = character
    }
    
    public var fullName: String {
        "\(character.attributes.name)"
    }
    
    public var birthAndDeathDate: NSAttributedString {
        guard let born = character.attributes.born else {
            return "Born: Unknown".createAttributedString(boldRange: "Born:")
        }
        if let died = character.attributes.died {
            let bornString = "Born: \(born)".createAttributedString(boldRange: "Born:")
            let diedString = "Died: \(died)".createAttributedString(boldRange: "Died:")
            let combinedString = NSMutableAttributedString()
            combinedString.append(bornString)
            combinedString.append(NSAttributedString(string: "\n"))
            combinedString.append(diedString)
            return combinedString
        } else {
            return "Born: \(born)".createAttributedString(boldRange: "Born:")
        }
    }
    
    public var gender: NSAttributedString {
        guard let text = character.attributes.gender else {
            return "Gender: Unknown".createAttributedString(boldRange: "Gender:")
        }
        return "Gender: \(text)".createAttributedString(boldRange: "Gender:")
    }
    
    public var house: NSAttributedString {
        guard let text = character.attributes.house else {
            return "House: Unknown".createAttributedString(boldRange: "House:")
        }
        return "House: \(text)".createAttributedString(boldRange: "House:")
    }    
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: character.attributes.image ?? "") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        HPImageLoader.shared.fetchImage(with: url, completion: completion)
    }
}
