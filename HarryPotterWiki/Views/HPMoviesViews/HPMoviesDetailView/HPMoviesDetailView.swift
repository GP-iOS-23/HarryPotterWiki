//
//  HPMoviesDetailView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 06.01.2025.
//

import Foundation
import UIKit

final class HPMoviesDetailView: UIView {
    private let viewModel: HPMoviesDetailViewViewModel
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(HPMoviesDetailTableViewCell.self, forCellReuseIdentifier: HPMoviesDetailTableViewCell.identifier)
        table.register(HPMoviesMainInfoTableViewCell.self, forCellReuseIdentifier: HPMoviesMainInfoTableViewCell.identifier)
        table.register(HPMoviesDetailTrailerViewCell.self, forCellReuseIdentifier: HPMoviesDetailTrailerViewCell.identifier)
        table.register(HPMoviesDetailTrailerSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: HPMoviesDetailTrailerSectionHeaderView.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(frame: CGRect, viewModel: HPMoviesDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubview(tableView)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
    }
}
