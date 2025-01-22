//
//  HPPoitionsListViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 09.01.2025.
//

import Foundation
import UIKit

protocol HPPoitionsListViewViewModelDelegate: AnyObject {
    func didFetchInitialPoitions()
    func didLoadMorePoitions(with newIndexPaths: [IndexPath])
}

final class HPPoitionsListViewViewModel: NSObject {
    private var poitions: [HPPoition] = [] {
        didSet {
            for poition in poitions {
                let viewModel = HPPoitionCellViewModel(poition: poition)
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [HPPoitionCellViewModel] = []
    
    private var links: HPGetAllPoitionsResponse.Links? = nil
    private var isLoadingMorePoitions = false
    
    public weak var delegate: HPPoitionsListViewViewModelDelegate?
    
    public func fetchPoitions() {
        HPService.shared.execute(
            HPRequest.listPoitionsRequest,
            expecting: HPGetAllPoitionsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let poitions = responseModel.data
                let links = responseModel.links
                self?.poitions = poitions
                self?.links = links
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialPoitions()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalPoitions(url: URL) {
        guard !isLoadingMorePoitions else {
            return
        }
        isLoadingMorePoitions = true
        guard let request = HPRequest(url: url) else {
            isLoadingMorePoitions = false
            return
        }
        
        HPService.shared.execute(request, expecting: HPGetAllPoitionsResponse.self) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                let links = responseModel.links
                self.links = links
                
                let startingIndex = self.poitions.count
                let newIndexPaths = moreResults.enumerated().map {index,_ in
                    return IndexPath(row: startingIndex + index, section: 0)
                }
                self.poitions.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMorePoitions(with: newIndexPaths)
                    self.isLoadingMorePoitions = false
                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMorePoitions = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return links?.next != nil
    }
}

extension HPPoitionsListViewViewModel: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        poitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HPPoitionsTableViewCell.identifier,
            for: indexPath) as? HPPoitionsTableViewCell
        else {
            fatalError()
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let lastIndexPath = indexPaths.last,
              shouldShowLoadMoreIndicator,
              !cellViewModels.isEmpty,
              let nextUrlString = links?.next,
              let url = URL(string: nextUrlString),
              lastIndexPath.row >= poitions.count - 10,
              !isLoadingMorePoitions
        else {
            return
        }
        fetchAdditionalPoitions(url: url)
    }
}
