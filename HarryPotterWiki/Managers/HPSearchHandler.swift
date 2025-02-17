//
//  HPSearchHandler.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 24.01.2025.
//

import Foundation
import UIKit
import Combine

final class HPSearchHandler: NSObject, UISearchResultsUpdating {
    let searchQueryPublisher = PassthroughSubject<String, Never>()
    private weak var searchController: UISearchController?
    private var cancellables = Set<AnyCancellable>()
    
    func setup(searchController: UISearchController) {
        self.searchController = searchController
        searchController.searchResultsUpdater = self
        
        searchQueryPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { _ in }
            .store(in: &cancellables)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        searchQueryPublisher.send(query)
    }
}
