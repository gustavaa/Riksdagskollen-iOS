//
//  VotesFeedModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import Foundation

class VotesFeedModel {
    
    var currentPage = 1;
    var voteDocuments: [VotesDocument] = []
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        VotesService.fetchVotes(page: currentPage)
        { votesResult in
            self.voteDocuments.append(contentsOf: votesResult ?? [])
            self.currentPage += 1
            onDataFetched()
        } failure: { error in
            onError(error)
        }
    }
    
}
