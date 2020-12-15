//
//  DocumentFeedController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import Foundation
import UIKit


class DocumentFeedController: UITableViewController {
    
    private var model: DocumentModel!
    
    var party: Party!
    
    init(representative: Representative) {
        super.init(nibName: nil, bundle: nil)
        self.model = RepresentativeFeedModel(representative: representative)
    }
    
    init(party: Party) {
        super.init(nibName: nil, bundle: nil)
        self.model = PartyFeedModel(party: party)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestMoreData()
        LoadingOverlay.shared.showOverlay(in: view)
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 140
        tableView.register(PartyDocumentTableViewCell.nib(), forCellReuseIdentifier: PartyDocumentTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.documents.count
    }
    
    func requestMoreData () {
        model.loadNextPage(){
            self.tableView.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        } onError: {error in
            print("error \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model.documents.count {
           requestMoreData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PartyDocumentTableViewCell.identifier, for: indexPath) as! PartyDocumentTableViewCell
        cell.configure(with: model.documents[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partyDocVC = DocumentReaderController()
        partyDocVC.partyDocument = model.documents[indexPath.row]
        show(partyDocVC, sender: self)
    }
    
}

protocol DocumentModel {
    var documents: [PartyDocument] { get }
    func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()))
}

class RepresentativeFeedModel: DocumentModel {
    private var currentPage = 1
    var documents = [PartyDocument]()
    private var representative: Representative
    
    init(representative: Representative) {
        self.representative = representative
    }
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        RepresentativeService.fetchDocumentsForRepresentative(iid: representative.intressent_id, page: currentPage, success:
        { documents, _ in
            if let repDocs = documents {
                self.documents.append(contentsOf: repDocs)
            }
            self.currentPage += 1
            onDataFetched()
        }, failure: { error in
            onError(error)
        })
    }
}

class PartyFeedModel: DocumentModel {
    private var currentPage = 1
    var documents = [PartyDocument]()
    private var party: Party
    
    init(party: Party) {
        self.party = party
    }
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        PartyService.fetchDocumentsForParty(party: party, page: currentPage, success:
        { documents in
            if let repDocs = documents {
                self.documents.append(contentsOf: repDocs)
            }
            self.currentPage += 1
            onDataFetched()
        }, failure: { error in
            onError(error)
        })
    }
}




