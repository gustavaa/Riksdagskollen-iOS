//
//  DecisionsViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-04.
//

import Foundation
import UIKit

class DebateFeedController: UITableViewController {
    
    var model: DebateFeedModel
    
    init() {
        model = DebateFeedModel()
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        model = DebateFeedModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        tableView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if model.debateDocuments.count == 0 {
            requestMoreData()
            LoadingOverlay.shared.showOverlay(in: view)
        }
    }
    
    
    func setupTableview () {
        tableView.register(DebateFeedTableViewCell.nib(), forCellReuseIdentifier: DebateFeedTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.debateDocuments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DebateFeedTableViewCell.identifier) as! DebateFeedTableViewCell
        cell.configure(with: model.debateDocuments[indexPath.row])
        return cell
    }
    
    func requestMoreData () {
        model.loadNextPage(){
            self.tableView.reloadData()
            self.tableView.isHidden = false
            LoadingOverlay.shared.hideOverlayView()
        } onError: {error in
            print("error \(error)")
            // TODO: Handle error
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func refreshCellAt(indexPath: IndexPath){
        self.tableView.performBatchUpdates({}, completion: { _ in
       
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let replayVc = DebateReplayViewController()
        replayVc.setIntiatingDocument(intiatingDocument: model.debateDocuments[indexPath.row])
        show(replayVc, sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model.debateDocuments.count {
           requestMoreData()
        }
    }
    
    
}
