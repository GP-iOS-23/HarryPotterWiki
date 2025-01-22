//
//  HPSpells.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

struct HPSpell: Codable {
    let id: UUID
    let attributes: HPSpellAttributes
}
