//
//  HPSpellListView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.01.2025.
//

import Foundation
import UIKit

final class HPSpellListView: UIView {
    private let viewModel = HPSPellListViewViewModel()
    
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
        table.register(HPSpellTableViewCell.self, forCellReuseIdentifier: HPSpellTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchSpells()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, spinner)
        spinner.startAnimating()
        
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

extension HPSpellListView: HPSPellListViewViewModelDelegate {
    func didFetchInitialSpells() {
        spinner.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 1
        }
    }
    
    func didFetchAdditionalSpells(with indexPath: [IndexPath]) {
        tableView.performBatchUpdates { [weak self] in
            self?.tableView.insertRows(at: indexPath, with: .automatic)
        }
    }
}
