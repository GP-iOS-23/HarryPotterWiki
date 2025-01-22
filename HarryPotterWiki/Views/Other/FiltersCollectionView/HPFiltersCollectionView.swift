//
//  HPFiltersCollectionView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 13.01.2025.
//

import Foundation
import UIKit

protocol HPFiltersCollectionViewDelegate: AnyObject {
    func filtersCollectionView(_ collectionView: HPFiltersCollectionView, didSelectFilterAt indexPath: IndexPath)
}

protocol HPFiltersCollectionViewDataSource: AnyObject {
    func numberOfFilters(in collectionView: HPFiltersCollectionView, numberOfItemsInSection section: Int) -> Int
    func filtersCollectionView(_ collectionView: HPFiltersCollectionView, filterForItemAt index: Int) -> HPCharacterFilter
}

final class HPFiltersCollectionView: UIView {
    public weak var delegate: HPFiltersCollectionViewDelegate?
    public weak var dataSource: HPFiltersCollectionViewDataSource?
    
    private let filtersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            HPFiltersCollectionViewCell.self,
            forCellWithReuseIdentifier: HPFiltersCollectionViewCell.identifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    public func reloadData() {
        filtersCollectionView.reloadData()
    }
    
    private func setupView() {
        addSubview(filtersCollectionView)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            filtersCollectionView.topAnchor.constraint(equalTo: topAnchor),
            filtersCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            filtersCollectionView.rightAnchor.constraint(equalTo: rightAnchor),
            filtersCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension HPFiltersCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfFilters(in: self, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HPFiltersCollectionViewCell.identifier,
            for: indexPath) as? HPFiltersCollectionViewCell,
              let filter = dataSource?.filtersCollectionView(self, filterForItemAt: indexPath.row) else {
            fatalError()
        }
        cell.configure(with: filter)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: 150,
            height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filtersCollectionView(self, didSelectFilterAt: indexPath)
        collectionView.reloadItems(at: [indexPath])
    }
}
