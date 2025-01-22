//
//  HPCharacterDetailViewCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 24.12.2024.
//

import Foundation
import UIKit

final class HPCharacterDetailViewCell: UITableViewCell {
    static let identifier: String = "HPCharacterDetailViewCell"
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        infoLabel.text = nil
    }
    
    private func setupCell() {
        contentView.addSubview(infoLabel)
        contentView.backgroundColor = .clear
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5),
            infoLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            infoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.5),
        ])
    }
    
    public func configure(_ text: NSAttributedString) {
        infoLabel.attributedText = text
    }
}
