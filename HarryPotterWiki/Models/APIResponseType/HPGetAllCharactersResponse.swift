//
//  HPGetAllCharactersResponse.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 20.12.2024.
//

import Foundation

public struct HPGetAllCharactersResponse: Codable {
    struct Links: Codable {
        let first: String?
        let prev: String?
        let next: String?
        let last: String?
    }
    
    let data: [HPCharacter]
    let links: Links
}
