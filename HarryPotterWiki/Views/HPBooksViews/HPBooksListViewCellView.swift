//
//  HPBooksListViewCellView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.12.2024.
//

import Foundation
import UIKit

final class HPBooksListViewCellView: UITableViewCell {
    static let identifier = "HPBooksListViewCellView"
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(bookImageView, bookTitleLabel, bookAuthorLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
        bookTitleLabel.text = nil
        bookAuthorLabel.text = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            bookImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            bookImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            bookTitleLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
            bookTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 10),
            bookAuthorLabel.leftAnchor.constraint(equalTo: bookImageView.rightAnchor, constant: 10),
        ])
    }
    
    public func configureCell(with viewModel: HPBooksListViewCellViewModel) {
        bookTitleLabel.text = viewModel.bookTitle
        bookAuthorLabel.text = viewModel.bookAuthor
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.bookImageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
}
