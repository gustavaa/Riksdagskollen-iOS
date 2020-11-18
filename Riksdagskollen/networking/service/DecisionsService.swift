//
//  DecisionsService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-13.
//

import Foundation

class DecisionService {
    
    static func fetchDecisions(page: Int, success: @escaping((_ result: [DecisionDocument]) -> () ), failure: @escaping((_ error: String) -> ())) {
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "doktyp", value: "bet"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "dokstat", value: "beslutade"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: "\(page)"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: DecisionDocument.self, success: success, failure: failure)
    }
}
