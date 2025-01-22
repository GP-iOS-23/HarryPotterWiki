//
//  HPBookDetailViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 18.12.2024.
//

import Foundation
import UIKit

final class HPBookDetailViewViewModel {
    private let book: HPBook
    
    init(book: HPBook) {
        self.book = book
    }
    
    public var title: String {
        book.attributes.title
    }
    
    public var author: String {
        book.attributes.author
    }
    
    public var pages: String {
        String(book.attributes.pages)
    }
    
    public var dedication: String {
        book.attributes.dedication
    }
    
    public var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: book.attributes.releaseDate)
    }
    
    public var summary: String {
        book.attributes.summary
    }
    
    public func getCoverImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: book.attributes.cover) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        HPImageLoader.shared.fetchImage(with: url, completion: completion) 
    }
}
