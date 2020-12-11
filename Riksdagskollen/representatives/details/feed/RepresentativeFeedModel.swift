//
//  RepresentativeFeedModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-11.
//

import Foundation


class RepresentativeFeedModel {
    private var currentPage = 1
    var representativeDocuments = [PartyDocument]()
    private var representative: Representative
    
    init(representative: Representative) {
        self.representative = representative
    }
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        RepresentativeService.fetchDocumentsForRepresentative(iid: representative.intressent_id, page: currentPage, success:
        { documents, _ in
            if let repDocs = documents {
                self.representativeDocuments.append(contentsOf: repDocs)
            }
            self.currentPage += 1
            onDataFetched()
        }, failure: { error in
            onError(error)
        })
    }
    
    
}
