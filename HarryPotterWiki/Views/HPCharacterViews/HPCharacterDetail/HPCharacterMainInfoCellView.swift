//
//  HPCharacterMainInfoCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 29.12.2024.
//

import Foundation
import UIKit

final class HPCharacterMainInfoCellView: UITableViewCell {
    static let identifier = "HPCharacterMainInfoCell"
    
    private let mainInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.spacing = 10
        return stackView
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.tintColor = .secondarySystemFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bornAndDiedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let houseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    public func configure(with viewModel: HPCharacterCellViewModel) {
        fullNameLabel.text = viewModel.fullName
        bornAndDiedLabel.attributedText = viewModel.birthAndDeathDate
        genderLabel.attributedText = viewModel.gender
        houseLabel.attributedText = viewModel.house
        
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.characterImageView.image = image
                }
            case .failure:
                let image = UIImage(systemName: "person.fill")
                DispatchQueue.main.async {
                    self?.characterImageView.image = image
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        fullNameLabel.text = nil
        bornAndDiedLabel.text = nil
        genderLabel.text = nil
        houseLabel.text = nil
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubviews(mainInfoStackView, characterImageView)
        mainInfoStackView.addArrangedSubviews(
            fullNameLabel,
            bornAndDiedLabel,
            genderLabel,
            houseLabel
        )
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            characterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            characterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            characterImageView.heightAnchor.constraint(equalToConstant: 500),
            
            mainInfoStackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 16),
            mainInfoStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            mainInfoStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            mainInfoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
