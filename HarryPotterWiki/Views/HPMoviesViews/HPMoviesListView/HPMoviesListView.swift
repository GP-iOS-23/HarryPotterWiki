//
//  HPMoviesListView.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 05.01.2025.
//

import Foundation
import UIKit

protocol HPMoviesListViewDelegate: AnyObject {
    func hpMoviesListView(
        _ movieListView: HPMoviesListView,
        didSelect movie: HPMovie
    )
}

final class HPMoviesListView: UIView, HPMoviesListViewViewModelDelegate {
    public weak var delegate: HPMoviesListViewDelegate?
    
    private let viewModel = HPMoviesListViewViewModel()
    
    private let moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(HPMoviesListViewCellView.self, forCellReuseIdentifier: HPMoviesListViewCellView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        viewModel.fetchMovies()
        viewModel.delegate = self
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupView() {
        addSubview(moviesTableView)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviesTableView.topAnchor.constraint(equalTo: topAnchor),
            moviesTableView.leftAnchor.constraint(equalTo: leftAnchor),
            moviesTableView.rightAnchor.constraint(equalTo: rightAnchor),
            moviesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        moviesTableView.dataSource = viewModel
        moviesTableView.delegate = viewModel
    }
    
    func didFetchMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.moviesTableView.reloadData()
        }
    }
    
    func didSelectMovie(_ movie: HPMovie) {
        delegate?.hpMoviesListView(self, didSelect: movie)
    }
}
