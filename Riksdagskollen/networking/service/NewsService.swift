//
//  NewsService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-09.
//

import Foundation
import Alamofire

class NewsService {
    
    
    static func fetchNews(page: Int, success: @escaping((_ success: [NewsDocument]) -> ()), failure: @escaping ((_ error:String) -> ())) {
        var urlComponents = URLComponents(string: "/dokumentlista/")!
        let queryItems = [
            URLQueryItem(name: "avd", value: "aktuellt"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "lang", value: "sv"),
            URLQueryItem(name: "cmskategori", value: "startsida"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: "\(page)"),
        ]
        urlComponents.queryItems = queryItems
        RiksdagenBaseService.makeDocumentListJSONRequest(subUrl: urlComponents.string!, documentType: NewsDocument.self, success: success, failure: failure)
    }
}
