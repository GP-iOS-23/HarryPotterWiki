//
//  HPCharacaterDetailViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 23.12.2024.
//

import Foundation
import UIKit

final class HPCharacterDetailViewController: UIViewController {
    let viewModel: HPCharacterDetailViewViewModel
    let detailView: HPCharacterDetailView
    
    init(frame: CGRect, viewModel: HPCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = HPCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
