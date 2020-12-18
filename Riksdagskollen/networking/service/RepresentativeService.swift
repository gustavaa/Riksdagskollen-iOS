//
//  RepresentativeService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation
class RepresentativeService {
    
    static func fetchRepresentative(iid: String, party: String?, success: @escaping((_ result: Representative?) -> () ), failure: @escaping((_ error: String) -> ())) {
        
        if let rep = RepresentativeManager.shared.getRepresentative(iid: iid, party: party) {
            success(rep)
            return
        }
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "iid", value: iid),
            URLQueryItem(name: "utformat", value: "json"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeCachedRepresentativelistJSONRequest(subUrl: urlComponents.string!, success: { result in
            success(result?.first)
            if let rep = result?.first {
                RepresentativeManager.shared.addRepresentative(rep: rep)
            }
        }, failure: failure)
    }
    
    static func fetchAllCurrentRepresentatives(success: @escaping((_ result: [Representative]?) -> () ), failure: @escaping((_ error: String) -> ())){
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "utformat", value: "json"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeCachedRepresentativelistJSONRequest(subUrl: urlComponents.string!, success: success , failure: failure)
    }
    
    static func fetchDocumentsForRepresentative(iid: String, page: Int, success: @escaping((_ result: [PartyDocument]?,_ numberOfHits: String) -> () ), failure: @escaping((_ error: String) -> ())) {
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "iid", value: iid),
            URLQueryItem(name: "avd", value: "dokument"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: String(page)),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: PartyDocument.self, success: success, failure: failure)
    }
    
    static func fetchVoteStatisticsForRepresentative(iid: String, success: @escaping((_ Result: RepresentativeVoteStatistics?) -> ()), failure: @escaping((_ error: String) -> ())){
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "iid", value: iid),
            URLQueryItem(name: "gruppering", value: "namn"),
            URLQueryItem(name: "utformat", value: "XML")
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeVotelistXMLRequest(subUrl: urlComponents.string!, success: success, failure: failure)
    }
}
