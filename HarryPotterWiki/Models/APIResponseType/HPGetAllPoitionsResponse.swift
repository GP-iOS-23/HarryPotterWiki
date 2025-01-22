//
//  HPGetAllPoitionsResponse.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 09.01.2025.
//

import Foundation

public struct HPGetAllPoitionsResponse: Codable {
    struct Links: Codable {
        let first: String?
        let prev: String?
        let next: String?
        let last: String?
    }
    
    let data: [HPPoition]
    let links: Links
}
