//
//  HPCharactersListView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 21.12.2024.
//

import Foundation
import UIKit

protocol HPCharactersListViewDelegate: AnyObject {
    func hpCharacterListView(_ view: HPCharactersListView, didSelectCharacter character: HPCharacter)
    func hpCHaracterListView(_ view: HPCharactersListView, didSelectFilter filter: HPCharacterFilter, completion: @escaping (HPCharacterFilterOption?) -> Void)
}

final class HPCharactersListView: UIView {
    public weak var delegate: HPCharactersListViewDelegate?
    
    private let viewModel = HPCharacterViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.register(
            HPCharacterCollectionViewCellView.self,
            forCellWithReuseIdentifier: HPCharacterCollectionViewCellView.identifier)
        collectionView.register(HPCharacterListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HPCharacterListHeaderView.identifier)
        collectionView.register(
            HPFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: HPFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        viewModel.delegate = self
        viewModel.fetchCharacter()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        collectionView.prefetchDataSource = viewModel
    }
}

extension HPCharactersListView: HPCharacterViewViewModelDelegate {
//    func didSelectFilter(_ filter: HPCharacterFilter) -> HPCharacterFilterOption? {
//        delegate?.hpCHaracterListView(self, didSelectFilter: filter)
//    }
    func didSelectFilter(_ filter: HPCharacterFilter, completion: @escaping (HPCharacterFilterOption?) -> Void) {
        delegate?.hpCHaracterListView(self, didSelectFilter: filter, completion: completion)
    }
    
    func didUpdateCharacters() {
        collectionView.reloadData()
    }
    
    func didSelectCharacter(_ character: HPCharacter) {
        delegate?.hpCharacterListView(self, didSelectCharacter: character)
    }
    
    func didFetchInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didUpdateHeader() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            if let header = collectionView.supplementaryView(
                forElementKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(item: 0, section: 0)) as? HPCharacterListHeaderView {
                
                header.configure(delegate: viewModel, dataSource: viewModel)
            }
        }
    }
}
