//
//  HPBookDetailView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 19.12.2024.
//

import Foundation
import UIKit

final class HPBookDetailView: UIView {
    
    private let viewModel: HPBookDetailViewViewModel
    
    private let attributesView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let bookAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookCoverView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bookPagesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookDedicationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bookSummaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18, weight: .semibold)
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let attributesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    init(frame: CGRect, viewModel: HPBookDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(attributesView)
        attributesView.addSubviews(bookCoverView, attributesStackView, /*bookTitleLabel,*/ bookSummaryTextView)
        attributesStackView.addArrangedSubviews(bookAuthorLabel, bookPagesLabel, bookReleaseDateLabel, bookDedicationLabel)
        sendSubviewToBack(attributesView)
        
        setupConstraints()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupViews() {
        bookAuthorLabel.text      = "Author: \(viewModel.author)"
        bookPagesLabel.text       = "Pages: \(viewModel.pages)"
        bookReleaseDateLabel.text = "Released at: \(viewModel.releaseDate)"
        bookDedicationLabel.text  = "Dedicated: \(viewModel.dedication)"
        bookSummaryTextView.text  = viewModel.summary
        
        viewModel.getCoverImage(completion: { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.bookCoverView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
            }
        })
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            attributesView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            attributesView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 16),
            attributesView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -16),
            attributesView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            bookCoverView.topAnchor.constraint(equalTo: attributesView.topAnchor, constant: 10),
            bookCoverView.leftAnchor.constraint(equalTo: attributesView.leftAnchor, constant: 10),
            bookCoverView.widthAnchor.constraint(equalTo: attributesView.widthAnchor, multiplier: 0.4),
            bookCoverView.heightAnchor.constraint(equalTo: attributesView.heightAnchor, multiplier: 0.4),
            
            attributesStackView.topAnchor.constraint(equalTo: attributesView.topAnchor, constant: 10),
            attributesStackView.leftAnchor.constraint(equalTo: bookCoverView.rightAnchor, constant: 10),
            attributesStackView.rightAnchor.constraint(equalTo: attributesView.rightAnchor, constant: -10),
            
            bookSummaryTextView.topAnchor.constraint(equalTo: bookCoverView.bottomAnchor, constant: 10),
            bookSummaryTextView.leftAnchor.constraint(equalTo: attributesView.leftAnchor, constant: 10),
            bookSummaryTextView.rightAnchor.constraint(equalTo: attributesView.rightAnchor, constant: -10),
            bookSummaryTextView.bottomAnchor.constraint(equalTo: attributesView.bottomAnchor, constant: -10),
        ])
    }
}
