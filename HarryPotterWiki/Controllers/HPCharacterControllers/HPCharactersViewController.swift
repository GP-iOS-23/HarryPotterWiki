//
//  CharactersViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPCharactersViewController: UIViewController, HPCharactersListViewDelegate {
    private let characterListView = HPCharactersListView()
    private var option: HPCharacterFilterOption? = nil
    private var searchController: UISearchController?
    private var searchResultsVC: HPSearchResultsViewController?
    private var searchHandler: HPSearchHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchHandler = HPSearchHandler()
        let viewModel = HPSearchResultsViewViewModel(searchHandler: searchHandler)
        
        searchResultsVC = HPSearchResultsViewController(
            viewModel: viewModel,
            searchHandler: searchHandler
        )
        
        searchResultsVC?.delegate = self
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchHandler.setup(searchController: searchController!)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        self.searchHandler = searchHandler
    }
    
    private func setupView() {
        characterListView.delegate = self
        
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func hpCharacterListView(_ view: HPCharactersListView, didSelectCharacter character: HPCharacter) {
        let viewModel = HPCharacterDetailViewViewModel(character: character)
        navigationController?.pushViewController(HPCharacterDetailViewController(frame: .zero, viewModel: viewModel), animated: true)
    }
    
    func hpCHaracterListView(_ view: HPCharactersListView, didSelectFilter filter: HPCharacterFilter, completion: @escaping  (HPCharacterFilterOption?) -> Void){
        let viewModel = HPFilterOptionsTableViewViewModel(filter: filter)
        let vc = HPCharacterFilterViewController(viewModel: viewModel)
        
        vc.onApplyFilter = { option in
            completion(option)
        }
        
        present(vc, animated: true)
    }
}

extension HPCharactersViewController: HPSearchResultsViewControllerDelegate {
    func didSelectCharacter(_ character: HPCharacter) {
        let viewModel = HPCharacterDetailViewViewModel(character: character)
        navigationController?.pushViewController(
            HPCharacterDetailViewController(frame: .zero, viewModel: viewModel),
            animated: true
        )
    }
}
