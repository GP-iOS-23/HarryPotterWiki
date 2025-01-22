//
//  HPMovies.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

struct HPMovie: Codable {
    let id: UUID
    let attributes: HPMovieAttributes
}
