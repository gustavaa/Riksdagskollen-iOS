//
//  ProtocolService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-14.
//

import Foundation

class ProtocolService {
    
    static func fetchProtocols(page: Int, success: @escaping((_ result: [PartyDocument]?) -> () ), failure: @escaping((_ error: String) -> ())) {
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "doktyp", value: "prot"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: String(page)),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: PartyDocument.self, success: success, failure: failure)
    }
}
