//
//  RepresentativeService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation
class RepresentativeService {
    
    static func fetchRepresentative(iid: String, success: @escaping((_ result: Representative?) -> () ), failure: @escaping((_ error: String) -> ())) {
        var urlComponents = URLComponents()
        let queryItems = [
            URLQueryItem(name: "iid", value: iid),
            URLQueryItem(name: "utformat", value: "json"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeRepresentativelistJSONRequest(subUrl: urlComponents.string!, success: {result in success(result?.first)}, failure: failure)
    }
}
