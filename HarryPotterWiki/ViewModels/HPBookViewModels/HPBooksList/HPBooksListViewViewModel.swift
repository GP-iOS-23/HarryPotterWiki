//
//  BooksViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.12.2024.
//

import Foundation
import UIKit

protocol HPBooksListViewViewModelDelegate: AnyObject {
    func didLoadBooks()
    func didSelectBook(_ book: HPBook)
}

final class HPBooksListViewViewModel: NSObject {
    public weak var delegate: HPBooksListViewViewModelDelegate?
    
    private var books: [HPBook] = [] {
        didSet {
            books.forEach { book in
                let viewModel = HPBooksListViewCellViewModel(
                    bookTitle: book.attributes.title,
                    bookAuthor: book.attributes.author,
                    bookImageURL: URL(string: book.attributes.cover)
                )
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [HPBooksListViewCellViewModel] = []
    
    public func fetchBooks() {
        HPService.shared.execute(.listBooksRequest, expecting: HPGetAllBooksResponse.self) { [weak self] result in
            switch result {
            case .success(let result):
                self?.books = result.data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadBooks()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension HPBooksListViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HPBooksListViewCellView.identifier,
            for: indexPath) as? HPBooksListViewCellView
        else {
            fatalError("Failed to create cell")
        }
        cell.configureCell(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = books[indexPath.row]
        delegate?.didSelectBook(book)
    }
}


