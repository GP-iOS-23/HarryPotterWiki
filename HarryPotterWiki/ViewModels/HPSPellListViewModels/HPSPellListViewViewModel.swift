//
//  HPSPellListViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation
import UIKit

protocol HPSPellListViewViewModelDelegate: AnyObject {
    func didFetchInitialSpells()
    func didFetchAdditionalSpells(with indexPath: [IndexPath])
}

final class HPSPellListViewViewModel: NSObject {
    private var spells: [HPSpell] = [] {
        didSet {
            for spell in spells {
                let viewModel = HPSpellTableViewCellViewModel(spell: spell)
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [HPSpellTableViewCellViewModel] = []
    
    private var links: HPGetAllSpellsReponse.Links? = nil
    private var isLoadingMoreSpells: Bool = false
    
    public weak var delegate: HPSPellListViewViewModelDelegate?
    
    public func fetchSpells() {
        HPService.shared.execute(
            HPRequest.listSpellsRequest,
            expecting: HPGetAllSpellsReponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let spells = responseModel.data
                let links = responseModel.links
                self?.spells = spells
                self?.links = links
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialSpells()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalSpells(url: URL) {
        guard !isLoadingMoreSpells else {
            return
        }
        isLoadingMoreSpells = true
        
        guard let request = HPRequest(url: url) else {
            isLoadingMoreSpells = false
            return
        }
        
        HPService.shared.execute(request, expecting: HPGetAllSpellsReponse.self) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                let links = responseModel.links
                self.links = links
                
                let startingIndex = self.spells.count
                let newIndexPaths = moreResults.enumerated().map {index,_ in
                    return IndexPath(row: startingIndex + index, section: 0)
                }
                self.spells.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    self.delegate?.didFetchAdditionalSpells(with: newIndexPaths)
                    self.isLoadingMoreSpells = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreSpells = false
            }
        }
    }
}

extension HPSPellListViewViewModel: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        spells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HPSpellTableViewCell.identifier,
            for: indexPath) as? HPSpellTableViewCell
        else {
            fatalError()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndexPath = indexPaths.last,
              !cellViewModels.isEmpty,
              let nextUrlString = links?.next,
              let url = URL(string: nextUrlString),
              lastIndexPath.row >= spells.count - 10,
              !isLoadingMoreSpells
        else {
            return
        }
        fetchAdditionalSpells(url: url)
    }
}
