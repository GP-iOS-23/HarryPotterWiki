//
//  HPBook.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

public struct HPBookAttributes: Codable {
    let author: String
    let cover: String
    let dedication: String
    let pages: Int
    let releaseDate: Date
    let summary: String
    let slug: String
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case author, cover, dedication, pages, summary, slug, title
        case releaseDate = "release_date"
    }
}
