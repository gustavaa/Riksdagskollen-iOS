//
//  VotesController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import Foundation
import UIKit

class VotingFeedController: UITableViewController {
    
    let model: VotingFeedModel = VotingFeedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
    }
    override func viewDidAppear(_ animated: Bool) {
        requestMoreData()
    }
    
    func setupTableview () {
        tableView.register(VotingFeedTableViewCell.nib(), forCellReuseIdentifier: VotingFeedTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.voteDocuments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VotingFeedTableViewCell.identifier) as! VotingFeedTableViewCell
        cell.configure(with: model.voteDocuments[indexPath.row])

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
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = VotingDetailsViewController()
        detailsVc.votingDocument = model.voteDocuments[indexPath.row]
        present(detailsVc, animated: true, completion: {})
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model.voteDocuments.count {
           requestMoreData()
        }
    }
    
    
}
