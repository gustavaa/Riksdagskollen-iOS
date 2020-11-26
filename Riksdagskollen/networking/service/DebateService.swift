//
//  DebateService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation

class DebateService {
    
    static func fetchDebates(page: Int, success: @escaping((_ result: [PartyDocument]) -> () ), failure: @escaping((_ error: String) -> ())) {
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "doktyp", value: "ip,bet,kam-ad"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "webbtv", value: "1"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: "\(page)"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: PartyDocument.self, success: success, failure: failure)
    }
    
    static func getProtocolForDate(date: String, rm: String, success: @escaping((_ result: [PartyDocument]) -> () ), failure: @escaping((_ error: String) -> ())) {
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "doktyp", value: "prot"),
            URLQueryItem(name: "rm", value: rm.addingPercentEncoding(withAllowedCharacters: .alphanumerics)),
            URLQueryItem(name: "from", value: date),
            URLQueryItem(name: "tom", value: date),
            URLQueryItem(name: "sort", value: "rel"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "utformat", value: "json"),
        ]
        urlComponents.queryItems = queryItems
        
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: PartyDocument.self, success: success, failure: failure)
    }
    
    static func getSpeech(protId: String, speechNo: String, success: @escaping((_ result: Speech?) -> () ), failure: @escaping((_ error: String) -> ())){
        var urlComponents = URLComponents()
        let path = "\(protId)-\(speechNo)/json"
        urlComponents.path = path
        
        RiksdagenBaseService.makeSpeechJSONRequest(subUrl: urlComponents.string!, success: success, failure: failure)
    }
}
