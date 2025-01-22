//
//  HPCharacterFilterTableViewViewModel.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.01.2025.
//

import Foundation
import UIKit

final class HPFilterOptionsTableViewViewModel: NSObject {
    private var filter: HPCharacterFilter
    
    public var applyFilterOption: (() -> Void)?
    public var selectedOption: HPCharacterFilterOption? {
        filter.selectedValue
    }
    
    public var title: String {
        filter.type.displayName
    }
    
    init(filter: HPCharacterFilter) {
        self.filter = filter
    }
}

extension HPFilterOptionsTableViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filter.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HPFilterTableViewCell.identifier,
            for: indexPath) as? HPFilterTableViewCell
        else {
            fatalError()
        }
        if filter.selectedValue != nil,
           filter.selectedValue == filter.options[indexPath.row]
        {
            cell.configure(with: filter.options[indexPath.row].title, isSelected: true)
        } else {
            cell.configure(with: filter.options[indexPath.row].title, isSelected: false)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        filter.selectedValue = filter.options[indexPath.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: HPFilterOptionsTableViewFooter.identifier) as? HPFilterOptionsTableViewFooter
        else {
            fatalError()
        }
        footer.configure(self)
        return footer
    }
}
