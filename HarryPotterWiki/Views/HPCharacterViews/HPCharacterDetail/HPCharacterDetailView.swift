//
//  HPCharacterDetailView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 23.12.2024.
//

import Foundation
import UIKit

final class HPCharacterDetailView: UIView {
    private let viewModel: HPCharacterDetailViewViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HPCharacterDetailViewCell.self, forCellReuseIdentifier: HPCharacterDetailViewCell.identifier)
        tableView.register(HPCharacterMainInfoCellView.self, forCellReuseIdentifier: HPCharacterMainInfoCellView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(frame: CGRect, viewModel: HPCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        setupTableView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient(with: [viewModel.houseColor, UIColor.systemBackground], locations: [0.0, 1.0])
    }
    
    private func setupTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
