//
//  HPSearchResultsViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 22.01.2025.
//

import Foundation
import Combine

protocol HPSearchResultsViewViewModelDelegate: AnyObject {
    func didUpdateSearchResults()
    func didFailSearch(with error: Error)
}

final class HPSearchResultsViewViewModel {
    private let searchService: HPSearchServiceProtocol
    private let searchHandler: HPSearchHandler
    var cancellables = Set<AnyCancellable>()
    
    @Published var characters: [HPCharacter] = []
    @Published var error: Error?
    
    weak var delegate: HPSearchResultsViewViewModelDelegate?
    
    public var cellViewModels: [HPCharacterCollectionViewCellViewModel] {
        characters.map { HPCharacterCollectionViewCellViewModel(character: $0) }
    }
    
    
    init(searchService: HPSearchServiceProtocol = HPSearchService(), searchHandler: HPSearchHandler) {
        self.searchService = searchService
        self.searchHandler = searchHandler
        setupBindings()
    }
    
    public func performFetch(query: String) {
        searchService.searchCharacters(query: query) { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                self?.delegate?.didUpdateSearchResults()
            case .failure(let error):
                self?.characters = []
                self?.delegate?.didFailSearch(with: error)
            }
        }
    }
    
    private func setupBindings() {
        searchHandler.searchQueryPublisher.sink { [weak self] query in
            self?.performFetch(query: query)
        }
        .store(in: &cancellables)
    }
}
