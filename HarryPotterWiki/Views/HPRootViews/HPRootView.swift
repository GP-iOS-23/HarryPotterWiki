//
//  HPRootView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

protocol HPRootViewDelegate: AnyObject {
    func hpRootView(
        _ hpRootView: HPRootView,
        didSelectSection section: HPRootViewSection
    )
}

final class HPRootView: UIView {
    
    public weak var delegate: HPRootViewDelegate?
    
    private let viewModel = HPRootViewViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HPRootViewCell.self, forCellWithReuseIdentifier: HPRootViewCell.cellIdentifier)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        translatesAutoresizingMaskIntoConstraints = false
        viewModel.delegate = self
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
    }
}

extension HPRootView: HPRootViewViewModelDelegate {
    func didSelectSection(with type: HPRootViewSection) {
        delegate?.hpRootView(self, didSelectSection: type)
    }
}
