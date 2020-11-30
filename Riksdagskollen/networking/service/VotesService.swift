//
//  RepresentativeService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation
class VotesService {
    
    static func fetchVotes(page: Int, success: @escaping((_ result: [VotingDocument]?) -> () ), failure: @escaping((_ error: String) -> ())) {
        
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "doktyp", value: "votering"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: "\(page)"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: VotingDocument.self, success: success, failure: failure)
    }
    
    static func fetchBetForVotingDocment(votingDocument: VotingDocument, success: @escaping((String) -> () ), failure: @escaping((_ error: String) -> ())){
        let stringUrl = "https://riksdagen.se/sv/dokument-lagar/arende/betankande/_\(votingDocument.searchableBetId)";
        let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        
        _ = RiksdagenBaseService.makeStringRequest(url: url, success: success, failure: failure)
    }
    
    static func fetchMotionById(id: String,  success: @escaping((_ result: [PartyDocument]?) -> () ), failure: @escaping((_ error: String) -> ())) {
        
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "sok", value: id.addingPercentEncoding(withAllowedCharacters: .alphanumerics)),
            URLQueryItem(name: "doktyp", value: "mot,prop"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "utformat", value: "json"),
        ]
        
        urlComponents.percentEncodedQueryItems = queryItems        
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: PartyDocument.self, success: success, failure: failure)
    }
}
