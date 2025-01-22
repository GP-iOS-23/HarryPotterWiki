//
//  HPCharacter.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

public struct HPCharacter: Codable {
    let id: UUID
    let attributes: HPCharacterAttributes
}
