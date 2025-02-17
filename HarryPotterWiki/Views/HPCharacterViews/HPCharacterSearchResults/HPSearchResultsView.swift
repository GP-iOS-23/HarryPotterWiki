//
//  HPSearchResultsView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 23.01.2025.
//

import Foundation
import UIKit

protocol HPSearchResultsViewDelegate: AnyObject {
    func hpSearchResultsView(_ view: HPSearchResultsView, didSelectCharacter character: HPCharacter)
}

final class HPSearchResultsView: UIView {
    private let viewModel: HPSearchResultsViewViewModel
    
    public weak var delegate: HPSearchResultsViewDelegate?
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            HPCharacterCollectionViewCellView.self,
            forCellWithReuseIdentifier: HPCharacterCollectionViewCellView.identifier)
        return collectionView
    }()
    
    init(viewModel: HPSearchResultsViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HPSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HPCharacterCollectionViewCellView.identifier,
            for: indexPath
        ) as? HPCharacterCollectionViewCellView else {
            fatalError()
        }
        cell.configure(with: viewModel.cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = (bounds.width-30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.hpSearchResultsView(self, didSelectCharacter: viewModel.characters[indexPath.row])
    }
}
