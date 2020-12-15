//
//  PartyService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import Foundation


class PartyService {
    
    static func fetchDocumentsForParty(party: Party, page: Int, success: @escaping((_ result: [PartyDocument]?) -> () ), failure: @escaping((_ error: String) -> ())){
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "avd", value: "dokument"),
            URLQueryItem(name: "del", value: "dokument"),
            URLQueryItem(name: "fcs", value: "1"),
            URLQueryItem(name: "parti", value: party.id),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: "\(page)"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: PartyDocument.self, success: success, failure: failure)
    }
}
