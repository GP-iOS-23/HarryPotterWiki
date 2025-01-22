//
//  HPMoviesMainInfoTableViewCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 07.01.2025.
//

import Foundation

final class HPMoviesMainInfoTableViewCellViewModel {
    private let movie: HPMovie
    
    public var title: String {
        movie.attributes.title
    }
    
    public var directors: NSAttributedString {
        let text = movie.attributes.directors.joined(separator: ", ")
        return "Directors: \(text)".createAttributedString(boldRange: "Directors: ")
    }
    
    public var releaseDate: NSAttributedString {
        "Released at: \(movie.attributes.releaseDate)".createAttributedString(boldRange: "Released at:")
    }
    
    public var distributors: NSAttributedString {
        let text = movie.attributes.distributors.joined(separator: ", ")
        return "Distributors: \(text)".createAttributedString(boldRange: "Distributors:")
    }
    
    init(movie: HPMovie) {
        self.movie = movie
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: movie.attributes.poster) else {
            return print("Error: invalid URL")
        }
        HPImageLoader.shared.fetchImage(with: url, completion: completion)
    }
}
