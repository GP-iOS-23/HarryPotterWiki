//
//  HPMoviesListViewCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 05.01.2025.
//

import Foundation

final class HPMoviesListViewCellViewModel: Hashable, Equatable {
    public let title: String
    private let imageURL: String
    
    init(movie: HPMovie) {
        self.title = movie.attributes.title
        self.imageURL = movie.attributes.poster
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: imageURL) else {
            return completion(.failure(URLError(.badURL)))
        }
        
        HPImageLoader.shared.fetchImage(with: url, completion: completion)
    }
    
    static func == (lhs: HPMoviesListViewCellViewModel, rhs: HPMoviesListViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(imageURL)
    }
}
