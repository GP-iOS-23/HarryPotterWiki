//
//  HPFiltersCollectionViewCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 13.01.2025.
//

import Foundation
import UIKit

final class HPFiltersCollectionViewCell: UICollectionViewCell {
    static let identifier = "HPFiltersCollectionViewCell"
    
    private let activateFilterButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        activateFilterButton.setTitleColor(.label, for: .normal)
    }
    
    public func configure(with filter: HPCharacterFilter) {
        activateFilterButton.setTitle(filter.selectedValue?.title ?? filter.type.displayName, for: .normal)
        activateFilterButton.setTitleColor(filter.isSelected ? .white : .label, for: .normal)
        activateFilterButton.backgroundColor = filter.isSelected ? .systemBlue : .secondarySystemFill
    }
    
    private func setupView() {
        contentView.addSubview(activateFilterButton)
        
        NSLayoutConstraint.activate([
            activateFilterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            activateFilterButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            activateFilterButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            activateFilterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}
