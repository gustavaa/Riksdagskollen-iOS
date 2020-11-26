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
    
    struct DocumentListResponse<T:Codable>: Codable {
        public var dokumentlista: DocumentList
        
        struct DocumentList: Codable {
            public var dokument: [T]
        }
    }
    
    struct RepresentativeListResponse: Codable {
        public var personlista: PersonList
        
    }
    
    class PersonList: Codable {
        public var person: [Representative]?
        
        enum CodingKeys: CodingKey {
            case person
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            person = try? container.decodeIfPresent([Representative].self, forKey: .person)
            if person == nil {
                if let rep = try? container.decodeIfPresent(Representative.self, forKey: .person) {
                    person = [rep]
                }
            }
        }
    }
    
    struct SpeechResponse: Codable {
        public var anforande: Speech
    }
    
   
    static func makeDocumentListJSONRequest<T>(subUrl: String, documentType: T.Type, success: @escaping(([T]) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        let url = URL(string: "\(HOST)/dokumentlista/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        makeJSONRequest(url: url!, responseType: DocumentListResponse<T>.self, success: {response in success(response.dokumentlista.dokument)}, failure: failure);
    }
    
    static func makeRepresentativelistJSONRequest(subUrl: String, success: @escaping(([Representative]?) -> Void), failure: @escaping((String) -> Void)){
        let url = URL(string: "\(HOST)/personlista/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        makeJSONRequest(url: url!, responseType: RepresentativeListResponse.self, success: {response in success(response.personlista.person)}, failure: failure)
    }
    
    static func makeSpeechJSONRequest(subUrl: String, success: @escaping((Speech?) -> Void), failure: @escaping((String) -> Void)){
        let url = URL(string: "\(HOST)/anforande/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        makeJSONRequest(url: url!, responseType: SpeechResponse.self, success: {response in success(response.anforande)}, failure: failure)
    }
    
    private static func makeJSONRequest<T>(url: URL, responseType: T.Type, success: @escaping((T) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        print("Making request to: \(String(describing: url.absoluteString))")
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseString { response in
            switch response.result {
                case .success(let value):
                    let json = value.data(using: .utf8)!
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: json)
                        success(decodedResponse)
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
    
    static func makeStringRequest(url: URL, success: @escaping((String) -> ()), failure: @escaping((String) -> Void)) -> DataRequest{
        print("Making string reuest to: \(String(describing: url.absoluteString))")
        return AF.request(url)
            .validate(statusCode: 200..<300)
            .responseString { response in
            switch response.result {
                case .success(let value):
                    success(value)
                    break
                case .failure(let error):
                    failure(error.errorDescription ?? "Something went wrong")
            }
        }
    }

    
}
