//
//  HPSpellTableViewCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation
import UIKit

final class HPSpellTableViewCell: UITableViewCell {
    static let identifier = "HPSpellTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let effectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let incantationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        contentView.addSubview(customBackgroundView)
        customBackgroundView.addSubview(stackView)
        stackView.addArrangedSubviews(nameLabel, categoryLabel, effectLabel, lightLabel, incantationLabel)
        
        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customBackgroundView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            customBackgroundView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: customBackgroundView.leftAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: customBackgroundView.rightAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: customBackgroundView.bottomAnchor, constant: -5),
        ])
    }
    
    public func configure(with viewModel: HPSpellTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        categoryLabel.attributedText = viewModel.category
        effectLabel.attributedText = viewModel.effect
        lightLabel.attributedText = viewModel.light
        incantationLabel.attributedText = viewModel.incantation
    }
}
