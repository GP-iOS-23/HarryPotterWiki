//
//  HPGetAllSpellsReponse.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation

struct HPGetAllSpellsReponse: Codable {
    struct Links: Codable {
        let first: String?
        let prev: String?
        let next: String?
        let last: String?
    }
    
    let data: [HPSpell]
    let links: Links
}
