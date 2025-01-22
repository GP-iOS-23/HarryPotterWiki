//
//  HPMoviesDetailTrailerSectionHeaderView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.01.2025.
//

import Foundation
import UIKit

final class HPMoviesDetailTrailerSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "HPMoviesDetailTrailerSectionHeaderView"
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Trailer"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let expandImage: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .right
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let expandButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public var didTapExpand: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        contentView.addSubviews(stackView, expandButton)
        contentView.sendSubviewToBack(stackView)
        stackView.addArrangedSubviews(sectionTitleLabel, expandImage)
        
        NSLayoutConstraint.activate([
            expandImage.widthAnchor.constraint(equalToConstant: 30),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            expandButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            expandButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            expandButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    @objc private func didTapExpandButton() {
        didTapExpand?()
    }
    
    public func configureButton(_ isExpanded: Bool) {
        expandButton.addTarget(self, action: #selector(didTapExpandButton), for: .touchUpInside)
        expandImage.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }
}
