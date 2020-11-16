//
//  DecisionModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-13.
//

import Foundation


class DecisionModel {
    
    var currentPage = 1;
    var decisionDocuments: [DecisionDocument] = []
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        DecisionService.fetchDecisions(page: currentPage)
        { decisionsResult in
            self.decisionDocuments.append(contentsOf: decisionsResult)
            self.currentPage += 1
            onDataFetched()
        } failure: { error in
            onError(error)
        }
    }
    
}
