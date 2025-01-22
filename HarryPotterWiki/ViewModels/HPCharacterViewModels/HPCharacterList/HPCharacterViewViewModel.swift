//
//  CharacterViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 20.12.2024.
//

import Foundation
import UIKit

protocol HPCharacterViewViewModelDelegate: AnyObject {
    func didFetchInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: HPCharacter)
    func didUpdateCharacters()
    func didSelectFilter(_ filter: HPCharacterFilter, completion: @escaping (HPCharacterFilterOption?) -> Void)
    func didUpdateHeader()
}

final class HPCharacterViewViewModel: NSObject {
    private var characters: [HPCharacter] = []
    private var filteredCharacters: [HPCharacter] = []
    private var cellViewModels: [HPCharacterCollectionViewCellViewModel] = []
    private var filters: [HPCharacterFilter] = [
        HPCharacterFilter(
            type: .isKeyCharacter,
            options: [.isKeyCharacter]
        ),
        HPCharacterFilter(
            type: .house,
            options: House.allCases.map { .house($0) }
        ),
        HPCharacterFilter(
            type: .bloodStatus,
            options: BloodStatus.allCases.map { .bloodStatus($0) }
        )
    ] {
        didSet {
            cachedActiveFilters = nil
        }
    }
    
    private var cachedActiveFilters: [HPCharacterFilter]?
    private var activeFilters: [HPCharacterFilter] {
        if cachedActiveFilters == nil {
            cachedActiveFilters = filters.filter { $0.isSelected }
        }
        return cachedActiveFilters ?? []
    }
    
    private var links: HPGetAllCharactersResponse.Links? = nil
    private var isLoadingMoreCharacters = false
    
    public weak var delegate: HPCharacterViewViewModelDelegate?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return links?.next != nil
    }
    
    private func updateCellViewModels() {
        // MARK: - Previous method updating cellViewModels
//        cellViewModels = filteredCharacters.map {
//            let imageURL = $0.attributes.image ?? ""
//            let house = $0.attributes.house ?? ""
//            return HPCharacterCollectionViewCellViewModel(
//                characterName: $0.attributes.name,
//                characterImageURL: URL(string: imageURL),
//                houseName: house
//            )
//        }
        
        cellViewModels = filteredCharacters.map { HPCharacterCollectionViewCellViewModel(character: $0) }
    }
    
    public func fetchCharacter() {
        HPService.shared.execute(
            .listCharactersRequest,
            expecting: HPGetAllCharactersResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let characters = responseModel.data
                let links = responseModel.links
                self?.characters = characters
                self?.filteredCharacters = characters
                self?.links = links
                self?.updateCellViewModels()
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = HPRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        HPService.shared.execute(request, expecting: HPGetAllCharactersResponse.self) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                self.links = responseModel.links
                
                self.characters.append(contentsOf: moreResults)
                
                let newFilteredCharacters = moreResults.filter { character in
                    self.activeFilters.allSatisfy { filter in
                        guard let selectedValue = filter.selectedValue else {
                            return true
                        }
                        
                        switch filter.type {
                        case .isKeyCharacter:
                            return character.attributes.isKeyCharacter
                        case .house:
                            guard let house = character.attributes.house
                            else { return false }
                            return house == selectedValue.title
                        case .bloodStatus:
                            guard let bloodStatus = character.attributes.bloodStatus
                            else { return false }
                            return bloodStatus == selectedValue.title
                        }
                    }
                }
                let startingIndex = self.filteredCharacters.count
                self.filteredCharacters.append(contentsOf: newFilteredCharacters)
                
                // MARK: - Previous iteration defining newCellViewModels
//                let newCellViewModels = newFilteredCharacters.map {
//                    let imageURL = $0.attributes.image ?? ""
//                    let house = $0.attributes.house ?? ""
//                    return HPCharacterCollectionViewCellViewModel(
//                        characterName: $0.attributes.name,
//                        characterImageURL: URL(string: imageURL),
//                        houseName: house
//                    )
//                }
                
                let newCellViewModels = newFilteredCharacters.map { HPCharacterCollectionViewCellViewModel(character: $0) }
                self.cellViewModels.append(contentsOf: newCellViewModels)
                
                let newIndexPaths = newFilteredCharacters.indices.map { IndexPath(row: startingIndex + $0, section: 0) }
                
                DispatchQueue.main.async {
                    self.updateCellViewModels()
                    self.delegate?.didLoadMoreCharacters(with: newIndexPaths)
                    self.isLoadingMoreCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreCharacters = false
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching
extension HPCharacterViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeFilters.isEmpty ? characters.count: filteredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HPCharacterCollectionViewCellView.identifier,
            for: indexPath
        ) as? HPCharacterCollectionViewCellView else {
            fatalError("Unsupported cell")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HPCharacterListHeaderView.identifier,
                for: indexPath
            ) as? HPCharacterListHeaderView else {
                fatalError("Unsupported supplementary footer view")
            }
            header.configure(delegate: self, dataSource: self)
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HPFooterLoadingCollectionReusableView.identifier,
                for: indexPath
            ) as? HPFooterLoadingCollectionReusableView else {
                fatalError("Unsupported supplementary footer view")
            }
            
            footer.startAnimating()
            return footer
            default :
            fatalError("Unsupported supplementary footer view")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let viewModel = cellViewModels[indexPath.row]
            viewModel.fetchImage { _ in }
        }
        
        guard let lastIndexPath = indexPaths.last,
              shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = links?.next,
              lastIndexPath.row >= filteredCharacters.count - 10,
              let url = URL(string: nextUrlString)
        else {
            return
        }
        fetchAdditionalCharacters(url: url)
    }
}

// MARK: - HPFiltersCollectionViewDelegate, HPFiltersCollectionViewDataSource
extension HPCharacterViewViewModel: HPFiltersCollectionViewDelegate, HPFiltersCollectionViewDataSource {
    
    func numberOfFilters(in collectionView: HPFiltersCollectionView, numberOfItemsInSection: Int) -> Int {
        return filters.count
    }
    
    func filtersCollectionView(_ collectionView: HPFiltersCollectionView, filterForItemAt index: Int) -> HPCharacterFilter {
        return filters[index]
    }
    
    func filtersCollectionView(_ collectionView: HPFiltersCollectionView, didSelectFilterAt indexPath: IndexPath) {
        filters[indexPath.row].isSelected.toggle()
        let filter = filters[indexPath.row]
        
        switch filter.type {
        case .isKeyCharacter:
            if filter.isSelected {
                filters[indexPath.row].selectedValue = HPCharacterFilterOption.isKeyCharacter
                applyFilters()
            } else {
                filters[indexPath.row].selectedValue = nil
                applyFilters()
            }
        case .bloodStatus:
            if filter.isSelected {
                delegate?.didSelectFilter(filter) { [weak self] option in
                    self?.filters[indexPath.row].selectedValue = option
                    self?.applyFilters()
                    DispatchQueue.main.async {
                        self?.delegate?.didUpdateHeader()
                    }
                }
            } else {
                filters[indexPath.row].selectedValue = nil
                applyFilters()
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didUpdateHeader()
                }
            }
        case .house:
            if filter.isSelected {
                delegate?.didSelectFilter(filter) { [weak self] option in
                    self?.filters[indexPath.row].selectedValue = option
                    self?.applyFilters()
                    DispatchQueue.main.async {
                        self?.delegate?.didUpdateHeader()
                    }
                }
            } else {
                filters[indexPath.row].selectedValue = nil
                applyFilters()
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didUpdateHeader()
                }
            }
        }
    }
    
    private func applyFilters() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            
            let filtered = self.characters.filter { character in
                return self.activeFilters.allSatisfy { filter in
                    guard let selectedValue = filter.selectedValue else {
                        return true
                    }
                    
                    // MARK: - Check isKeyCharacter filter applies
                    switch filter.type {
                    case .isKeyCharacter:
                        return character.attributes.isKeyCharacter
                    case .house:
                        guard let house = character.attributes.house
                        else { return false }
                        return house == selectedValue.title
                    case .bloodStatus:
                        guard let bloodStatus = character.attributes.bloodStatus
                        else { return false }
                        return bloodStatus == selectedValue.title
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.filteredCharacters = filtered
                self.updateCellViewModels()
                self.delegate?.didUpdateCharacters()
            }
        }
    }
}
