//
//  ProtocolsFeedModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-14.
//

import Foundation


class ProtocolsFeedModel {
    private var currentPage = 1
    var protocols = [PartyDocument]()
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        ProtocolService.fetchProtocols(page: currentPage, success:
        { docs in
            if let protocols = docs {
                self.protocols.append(contentsOf: protocols)
            }
            self.currentPage += 1
            onDataFetched()
        }, failure: { error in
            onError(error)
        })
    }
}
