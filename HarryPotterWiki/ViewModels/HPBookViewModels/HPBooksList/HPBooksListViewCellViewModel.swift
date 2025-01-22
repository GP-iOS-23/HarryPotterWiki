//
//  HPBooksListViewCellViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.12.2024.
//

import Foundation
import UIKit

final class HPBooksListViewCellViewModel: Hashable, Equatable {
    public let bookTitle: String
    public let bookAuthor: String
    private let bookImageURL: URL?
    
    public init(bookTitle: String, bookAuthor: String, bookImageURL: URL?) {
        self.bookTitle = bookTitle
        self.bookAuthor = bookAuthor
        self.bookImageURL = bookImageURL
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = bookImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        HPImageLoader.shared.fetchImage(with: url, completion: completion)
    }
    
    static func == (lhs: HPBooksListViewCellViewModel, rhs: HPBooksListViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(bookTitle)
        hasher.combine(bookAuthor)
        hasher.combine(bookImageURL)
    }
}
