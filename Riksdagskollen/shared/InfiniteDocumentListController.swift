//
//  InfiniteDocumentListController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-13.
//

import UIKit

class InfiniteDocumentListController: UITableViewController {
    
    let model: InfiniteDocumentListModel?
    
    init(model: InfiniteDocumentListModel) {
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.model.currentPage
        if indexPath.row + 1 == model.count {
            model.loadNextPage()
        }
    }
    // MARK: - Table view data source





}
