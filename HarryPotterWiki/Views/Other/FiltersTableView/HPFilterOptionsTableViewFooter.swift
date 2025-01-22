//
//  HPFilterTableViewFooter.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 20.01.2025.
//

import Foundation
import UIKit

final class HPFilterOptionsTableViewFooter: UITableViewHeaderFooterView {
    static let identifier = "HPFilterTableViewFooter"
    
    public var buttonDidTapped: (() -> Void)?
    
    private let activateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        contentView.addSubview(activateButton)
        
        NSLayoutConstraint.activate([
            activateButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            activateButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            activateButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            activateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    public func configure(_ viewModel: HPFilterOptionsTableViewViewModel) {
        self.buttonDidTapped = viewModel.applyFilterOption
    }
    
    private func setupButton() {
        activateButton.addTarget(self, action: #selector(applyFilterOption), for: .touchUpInside)
    }
    
    @objc private func applyFilterOption() {
        buttonDidTapped?()
    }
}
