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
        RiksdagenBaseService.makeRepresentativelistJSONRequest(subUrl: urlComponents.string!, success: { result in
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
        RiksdagenBaseService.makeRepresentativelistJSONRequest(subUrl: urlComponents.string!, success:{ result in
            RepresentativeManager.shared.addCurrentRepresentatives(representatives: result!)
            success(result)
        } , failure: failure)
    }
}
