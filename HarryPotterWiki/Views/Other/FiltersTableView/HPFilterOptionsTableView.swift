//
//  HPCharacterFilterTableView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.01.2025.
//

import Foundation
import UIKit

final class HPFilterOptionsTableView: UIView {
    private let viewModel: HPFilterOptionsTableViewViewModel
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(HPFilterTableViewCell.self, forCellReuseIdentifier: HPFilterTableViewCell.identifier)
        tableView.register(HPFilterOptionsTableViewFooter.self, forHeaderFooterViewReuseIdentifier: HPFilterOptionsTableViewFooter.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: HPFilterOptionsTableViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        configure(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubviews(titleLabel, tableView)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    private func configure(_ viewModel: HPFilterOptionsTableViewViewModel) {
        titleLabel.text = viewModel.title
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}

