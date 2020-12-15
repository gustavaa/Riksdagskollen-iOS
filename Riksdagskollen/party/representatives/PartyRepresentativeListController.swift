//
//  PartyRepresentativeListController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import Foundation
import UIKit


class PartyRepresentativeListController: UITableViewController {
    private var optionsButton: UIBarButtonItem!
    private var model: PartyRepresentativeListModel!
    private var currentPartyFilter: Set<String>!
    
    init(party: Party) {
        super.init(nibName: nil, bundle: nil)
        model = PartyRepresentativeListModel(party: party, onDataChange: {
            LoadingOverlay.shared.hideOverlayView()
            self.tableView.reloadData()
        })
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        
        if !RepresentativeManager.shared.representativesAreDownloaded {
            LoadingOverlay.shared.showOverlay(in: view)
        }
    }
    
    func setupTableview () {
        tableView.register(RepresentativeTableViewCell.nib(), forCellReuseIdentifier: RepresentativeTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.representatives.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepresentativeTableViewCell.identifier, for: indexPath) as! RepresentativeTableViewCell
        cell.configure(with: model.representatives[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepresentativeDetailsController(representative: model.representatives[indexPath.row])
        show(vc, sender: nil)
    }

}
