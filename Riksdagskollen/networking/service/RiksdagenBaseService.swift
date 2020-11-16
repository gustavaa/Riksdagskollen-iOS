//
//  RiksdagenBaseService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-09.
//

import Foundation
import Alamofire

class RiksdagenBaseService {
    
    public static let HOST = "https://data.riksdagen.se"
    
    struct APIResponse<T:Codable>: Codable {
        public var dokumentlista: DocumentList
        
        struct DocumentList: Codable {
            public var dokument: [T]
        }
    }
    
    static func makeDocumentListJSONRequest<T>(subUrl: String, documentType: T.Type, success: @escaping(([T]) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        let url = URL(string: HOST + subUrl)
        if url == nil {
            failure("Could not parse URL")
            return
        }
        
        AF.request(url!).responseString { response in
            switch response.result {
                case .success(let value):
                    let json = value.data(using: .utf8)!
                    do {
                        let decodedResponse = try JSONDecoder().decode(APIResponse<T>.self, from: json)
                        success(decodedResponse.dokumentlista.dokument)
                        break
                    } catch {
                        print(error)
                        failure(error.localizedDescription)
                    }
                case .failure(let error):
                    failure(error.errorDescription ?? "Something went wrong")
            }
        }
    }

    
}
