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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: HPSearchResultsViewController())
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
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
