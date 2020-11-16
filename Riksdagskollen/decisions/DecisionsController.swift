//
//  DecisionsViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-04.
//

import Foundation
import UIKit

class DecisionsController: UITableViewController {
    
    var model: DecisionModel
    
    init() {
        model = DecisionModel()
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
    }
    override func viewDidAppear(_ animated: Bool) {
        requestMoreData()
    }
    
    func setupTableview () {
        tableView.register(DecisionsTableViewCell.nib(), forCellReuseIdentifier: DecisionsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.decisionDocuments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DecisionsTableViewCell.identifier) as! DecisionsTableViewCell
        cell.configure(decisionDocument: model.decisionDocuments[indexPath.row])
//        print(cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize))

        //model.decisionDocuments[indexPath.row].initialHeight = cell.frame.height

        return cell
    }
    
    func requestMoreData () {
        model.loadNextPage(){
            self.tableView.reloadData()
        } onError: {error in
            print("error \(error)")
            // TODO: Handle error
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
//        if model.decisionDocuments[indexPath.row].isExpanded {
//            return UITableView.automaticDimension
//        } else if model.decisionDocuments[indexPath.row].initialHeight > 0 {
//            return UITableView.automaticDimension
//        } else {
//            return 150
//        }
    }
    
    func refreshCellAt(indexPath: IndexPath){
        self.tableView.performBatchUpdates({}, completion: { _ in
       
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.decisionDocuments[indexPath.row].isExpanded.toggle()
        let expanded = model.decisionDocuments[indexPath.row].isExpanded
        let cell = tableView.cellForRow(at: indexPath) as! DecisionsTableViewCell
        
        cell.setExpanded(expanded: expanded)
        
        self.tableView.performBatchUpdates({}, completion: { _ in })

    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model.decisionDocuments.count {
           requestMoreData()
        }
    }
    
    
}
