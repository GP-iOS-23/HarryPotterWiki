//
//  HPBookDetailViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 18.12.2024.
//

import Foundation
import UIKit

final class HPBookDetailViewController: UIViewController {
    let viewModel: HPBookDetailViewViewModel
    let detailView: HPBookDetailView
    
    init(frame: CGRect, viewModel: HPBookDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = HPBookDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupporeted detailView")
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
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
