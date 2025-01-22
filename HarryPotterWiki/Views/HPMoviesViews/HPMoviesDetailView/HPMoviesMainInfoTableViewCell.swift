//
//  HPMoviesMainInfoTableViewCell.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 06.01.2025.
//

import Foundation
import UIKit

final class HPMoviesMainInfoTableViewCell: UITableViewCell {
    static let identifier = "HPMoviesMainInfoTableViewCell"
    
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
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let directorsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let distributorsLabel: UILabel = {
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
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        directorsLabel.text = nil
        releaseDateLabel.text = nil
        distributorsLabel.text = nil    
    }
    
    public func configure(with viewModel: HPMoviesMainInfoTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        directorsLabel.attributedText = viewModel.directors
        releaseDateLabel.attributedText = viewModel.releaseDate
        distributorsLabel.attributedText = viewModel.distributors
        
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubviews(posterImageView, mainInfoStackView)
        mainInfoStackView.addArrangedSubviews(
            titleLabel,
            directorsLabel,
            releaseDateLabel,
            distributorsLabel
        )
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalToConstant: 500),
            
            mainInfoStackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            mainInfoStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            mainInfoStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            mainInfoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
