//
//  HPCharacterSearchViewController.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 05.01.2025.
//

import Foundation
import UIKit

protocol HPSearchResultsViewControllerDelegate: AnyObject {
    func didSelectCharacter(_ character: HPCharacter)
}

final class HPSearchResultsViewController: UIViewController {
    private let viewModel: HPSearchResultsViewViewModel
    private let resultsView: HPSearchResultsView
    private let searchHandler: HPSearchHandler
    
    public weak var delegate: HPSearchResultsViewControllerDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    init(viewModel: HPSearchResultsViewViewModel, searchHandler: HPSearchHandler) {
        self.viewModel = viewModel
        self.searchHandler = searchHandler
        self.resultsView = HPSearchResultsView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        resultsView.delegate = self
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubviews(resultsView, spinner)
        resultsView.isHidden = true
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resultsView.topAnchor.constraint(equalTo: view.topAnchor),
            resultsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func showErrorAlert(_ error: any Error) {
        let alertController = UIAlertController(
            title: "Something went wrong",
            message: "Please try again later.",
            preferredStyle: .alert
        )
        self.present(alertController, animated: true) {
            print("Failed to find any character\(error)")
        }
    }
    
    private func setupBindings() {
        viewModel.$characters
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.resultsView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let error else {
                    return
                }
                self?.showErrorAlert(error)
            }
            .store(in: &viewModel.cancellables)
    }
}

extension HPSearchResultsViewController: HPSearchResultsViewDelegate, HPSearchResultsViewViewModelDelegate {
    func didUpdateSearchResults() {
        DispatchQueue.main.async { [weak self] in
            self?.resultsView.reloadData()
            self?.resultsView.isHidden = false
            self?.spinner.stopAnimating()
            UIView.animate(withDuration: 0.4) {
                self?.resultsView.alpha = 1
            }
        }
    }
    
    func hpSearchResultsView(_ view: HPSearchResultsView, didSelectCharacter character: HPCharacter) {
        delegate?.didSelectCharacter(character)
    }
    
    
    func didFailSearch(with error: any Error) {
        showErrorAlert(error)
    }
}
