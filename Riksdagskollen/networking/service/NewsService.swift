//
//  NewsService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-09.
//

import Foundation
import Alamofire

class NewsService: RiksdagenBaseService {
    
    
    class func getNews(page: Int, success: @escaping((_ success: [NewsItem]?) -> ()), failure: @escaping ((_ error:String) -> ())) {
        var urlComponents = URLComponents(string: HOST)!
        urlComponents.path = "/dokumentlista/"
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
        print("Making request to \(urlComponents.url)")
        AF.request(urlComponents.url!).responseString { response in
            switch response.result {
                case .success(let value):
                    let json = value.data(using: .utf8)!
                    if let decodedResponse = try? JSONDecoder().decode(NewsResult.self, from: json) {
                        success(decodedResponse.dokumentlista.dokument)
                        break
                    }

                case .failure(let error):
                    failure(error.errorDescription ?? "Something went wrong")
            }
        }
    }
    
    
    
}
