//
//  HPRootViewCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit

final class HPRootViewCell: UICollectionViewCell {
    static let cellIdentifier = "HPRootViewCell"
    
    private let backroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let sectionName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = CGSize(width: -4, height: 4)
        label.layer.shadowOpacity = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(backroundImageView, sectionName)
        contentView.sendSubviewToBack(backroundImageView)
        setupConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sectionName.heightAnchor.constraint(equalToConstant: 25),
            
            backroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            sectionName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sectionName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 70),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backroundImageView.image = nil
        sectionName.text = nil
    }
    
    public func configure(with viewModel: HPRootViewCellViewModel) {
        backroundImageView.image = viewModel.sectionImage
        sectionName.text = viewModel.sectionName.upperCasedFirstLetter()
    }
}
