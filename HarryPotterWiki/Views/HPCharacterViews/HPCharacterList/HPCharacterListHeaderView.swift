//
//  HPCharacterListHeaderView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.01.2025.
//

import Foundation
import UIKit

final class HPCharacterListHeaderView: UICollectionReusableView {
    static let identifier = "HPCharacterListHeaderView"
    
    private var filtersView: HPFiltersCollectionView!
    
    public weak var delegate: HPFiltersCollectionViewDelegate?
    public weak var dataSource: HPFiltersCollectionViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        filtersView = HPFiltersCollectionView(frame: .zero)
        filtersView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(filtersView)
        
        NSLayoutConstraint.activate([
            filtersView.topAnchor.constraint(equalTo: topAnchor),
            filtersView.leftAnchor.constraint(equalTo: leftAnchor),
            filtersView.rightAnchor.constraint(equalTo: rightAnchor),
            filtersView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(delegate: HPFiltersCollectionViewDelegate, dataSource: HPFiltersCollectionViewDataSource) {
        filtersView.delegate = delegate
        filtersView.dataSource = dataSource
        filtersView.reloadData()
    }
}
