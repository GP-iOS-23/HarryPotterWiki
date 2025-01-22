//
//  HPMovieAttributes.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 05.01.2025.
//

import Foundation

public struct HPMovieAttributes: Codable {
    let title: String
    let poster: String
    let directors: [String]
    let producers: [String]
    let editors: [String]
    let cinematographers: [String]
    let musicComposers: [String]
    let screenwriters: [String]
    let distributors: [String]
    let boxOffice: String
    let budget: String
    let releaseDate: String
    let runningTime: String
    let rating: String
    let slug: String
    let summary: String
    let trailer: String
    
    private enum CodingKeys: String, CodingKey {
        case boxOffice = "box_office"
        case releaseDate = "release_date"
        case runningTime = "running_time"
        case musicComposers = "music_composers"
        case title, poster, directors, producers, editors, cinematographers, screenwriters, distributors, budget, rating, slug, summary, trailer
    }
}

extension HPMovieAttributes {
    var additionalInfo: [String] {
        let producers = producers.joined(separator: ", ")
        let editors = editors.joined(separator: ", ")
        let cinematographers = cinematographers.joined(separator: ", ")
        let musicComposers = musicComposers.joined(separator: ", ")
        let screenwriters = screenwriters.joined(separator: ", ")
        let info = [
            "Box office: \(boxOffice)",
            "Budget: \(budget)",
            "Running time: \(runningTime)",
            "Rating: \(rating)",
            "Producers: \(producers)",
            "Editors: \(editors)",
            "Cinematographers: \(cinematographers)",
            "Music composers: \(musicComposers)",
            "Screenwriters: \(screenwriters)",
            "\n\nFilm summary: \n\n\(summary)"
        ]
        return info
    }
}
