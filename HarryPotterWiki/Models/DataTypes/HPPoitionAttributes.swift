//
//  HPPoitionAttributes.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 09.01.2025.
//

import Foundation

struct HPPoitionAttributes: Codable {
    let name: String
    let effect: String?
    let difficulty: String?
    let ingridients: String?
    let sideEffects: String?
    let slug: String
    
    private enum CodingKeys: String, CodingKey {
        case name, effect, difficulty, ingridients, slug
        case sideEffects = "side_effects"
    }
}
