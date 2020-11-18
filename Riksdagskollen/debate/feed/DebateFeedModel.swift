//
//  DebateModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation


class DebateFeedModel {
    
    var currentPage = 1;
    var debateDocuments: [PartyDocument] = []
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        DebateService.fetchDebates(page: currentPage)
        { debatesResult in
            self.debateDocuments.append(contentsOf: debatesResult)
            self.currentPage += 1
            onDataFetched()
        } failure: { error in
            onError(error)
        }
    }
}
