//
//  HPPoitionsListView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 09.01.2025.
//

import Foundation
import UIKit

final class HPPoitionsListView: UIView {
    private let viewModel = HPPoitionsListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.isHidden = true
        table.register(HPPoitionsTableViewCell.self, forCellReuseIdentifier: HPPoitionsTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTableView()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchPoitions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        addSubviews(tableView, spinner)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.prefetchDataSource = viewModel
    }
}

extension HPPoitionsListView: HPPoitionsListViewViewModelDelegate {
    func didFetchInitialPoitions() {
        spinner.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 1
        }
    }
    
    func didLoadMorePoitions(with newIndexPaths: [IndexPath]) {
        tableView.performBatchUpdates { [weak self] in
            self?.tableView.insertRows(at: newIndexPaths, with: .fade)
        }
    }
}
