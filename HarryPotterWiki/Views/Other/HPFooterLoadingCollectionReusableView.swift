//
//  HPFooterLoadingCollectionReusableView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 21.12.2024.
//

import Foundation
import UIKit

final class HPFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "HPFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(spinner)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported footer")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
}
