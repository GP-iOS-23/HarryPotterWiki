//
//  HPSpellAttributes.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation

struct HPSpellAttributes: Codable {
    let slug: String
    let name: String
    let light: String?
    let category: String?
    let effect: String?
    let incantation: String?
}
