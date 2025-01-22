//
//  HPCharacterFilterViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.01.2025.
//

import Foundation
import UIKit

final class HPCharacterFilterViewController: UIViewController {
    private let filtersTableView: HPFilterOptionsTableView
    private let viewModel: HPFilterOptionsTableViewViewModel
    
    var onApplyFilter: ((HPCharacterFilterOption?) -> Void)?
    
    init(viewModel: HPFilterOptionsTableViewViewModel) {
        self.filtersTableView = HPFilterOptionsTableView(viewModel: viewModel)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupView()
        viewModel.applyFilterOption = { [weak self] in
            let selectedOption = viewModel.selectedOption
            self?.onApplyFilter?(selectedOption)
            self?.dismiss(animated: true)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(filtersTableView)
        
        NSLayoutConstraint.activate([
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            filtersTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            filtersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
