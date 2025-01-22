//
//  HPBooksListView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.12.2024.
//

import Foundation
import UIKit

protocol HPBooksListViewDelegate: AnyObject {
    func hpBookListView(
        _ bookListView: HPBooksListView,
        didSelectBook book: HPBook
    )
}

final class HPBooksListView: UIView, HPBooksListViewViewModelDelegate {
    public weak var delegate: HPBooksListViewDelegate?
    
    private let viewModel = HPBooksListViewViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HPBooksListViewCellView.self, forCellReuseIdentifier: HPBooksListViewCellView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .clear
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        setupConstraints()
        viewModel.delegate = self
        viewModel.fetchBooks()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func didLoadBooks() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didSelectBook(_ book: HPBook) {
        delegate?.hpBookListView(self, didSelectBook: book)
    }
}
