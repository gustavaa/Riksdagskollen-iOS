//
//  RiksdagenBaseService.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-09.
//

import Foundation
import Alamofire
import XMLParsing
import CoreData
import Cache

class RiksdagenBaseService {
    
    public static let HOST = "https://data.riksdagen.se"
    
    static let representativeCacheExpiryTime = 3600 * 24 * 2 // 2 days

    static let representativeCacheStorage = try? Storage<String, [Representative]>(
      diskConfig: DiskConfig(name: "RepresentativeCache", maxSize: 1024*1024*20), // 20MB
      memoryConfig: MemoryConfig(),
      transformer: TransformerFactory.forCodable(ofType: [Representative].self)
    )
    
    struct DocumentListResponse<T:Codable>: Codable {
        public var dokumentlista: DocumentList<T>
    }
    
    struct RepresentativeListResponse: Codable {
        public var personlista: PersonList
    }
    
    struct VoteListResponse: Codable {
        public var votering: RepresentativeVoteStatistics
    }
    
    class DocumentList<T:Codable>: Codable {
        public var dokument: [T]
        public var traffar: String
        
        enum CodingKeys: String, CodingKey {
            case dokument = "dokument"
            case traffar = "@traffar"
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            dokument = try container.decode([T].self, forKey: .dokument)
            traffar = try container.decode(String.self, forKey: .traffar)
        }
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
    
    static func makeDocumentListJSONRequest<T>(subUrl: String, documentType: T.Type, success: @escaping(([T], String) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        let url = URL(string: "\(HOST)/dokumentlista/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        makeJSONRequest(url: url!, responseType: DocumentListResponse<T>.self, success: {response in success(response.dokumentlista.dokument, response.dokumentlista.traffar)}, failure: failure);
    }
    
    static func makeRepresentativelistJSONRequest(subUrl: String, success: @escaping(([Representative]?) -> Void), failure: @escaping((String) -> Void)){
        let url = URL(string: "\(HOST)/personlista/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        if (try? representativeCacheStorage?.existsObject(forKey: subUrl)) == true {
            if let cacheHit = try? representativeCacheStorage?.object(forKey: subUrl) {
                success(cacheHit)
                return
            }
        }

        makeJSONRequest(url: url!, responseType: RepresentativeListResponse.self, success: {response in
            success(response.personlista.person)
            if let representatives = response.personlista.person {
                let expiryDate = Expiry.date(Date().addingTimeInterval(TimeInterval(representativeCacheExpiryTime)))
                representativeCacheStorage?.async.setObject(representatives, forKey: subUrl, expiry: expiryDate, completion: {_ in})
            }
        }, failure: failure)
    }
    
    let cacher = ResponseCacher(behavior: .modify({sessionTask, cachedResponse in
        return nil
    }))
    
    static func makeSpeechJSONRequest(subUrl: String, success: @escaping((Speech?) -> Void), failure: @escaping((String) -> Void)){
        let url = URL(string: "\(HOST)/anforande/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        makeJSONRequest(url: url!, responseType: SpeechResponse.self, success: {response in success(response.anforande)}, failure: failure)
    }
    
    static func makeVotelistXMLRequest(subUrl: String, success: @escaping((RepresentativeVoteStatistics?) -> Void), failure: @escaping((String) -> Void)){
        let url = URL(string: "\(HOST)/voteringlista/\(subUrl)")
        if url == nil {
            failure("Could not parse URL")
            return
        }
        makeXMLRequest(url: url!, responseType: VoteListResponse.self, success: {response in success(response.votering)}, failure: failure)
    }
    
    private static func makeJSONRequest<T>(url: URL, responseType: T.Type, success: @escaping((T) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        print("Making json request to: \(String(describing: url.absoluteString))")
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseString { response in
            switch response.result {
                case .success(let value):
                    let json = value.data(using: .utf8)!
                    DispatchQueue(label: "parsing", qos: .userInitiated).async {
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: json)
                            DispatchQueue.main.async {
                                success(decodedResponse)
                            }
                        } catch {
                            print(error)
                            failure(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    failure(error.errorDescription ?? "Something went wrong")
            }
        }
    }
    
    private static func makeJSONRequest<T>(url: URL, responseType: T.Type, decoder: JSONDecoder = JSONDecoder(), success: @escaping((T) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        print("Making json request to: \(String(describing: url.absoluteString))")
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseString { response in
            switch response.result {
                case .success(let value):
                    let json = value.data(using: .utf8)!
                    DispatchQueue(label: "parsing", qos: .userInitiated).async {
                        do {
                            let decodedResponse = try decoder.decode(T.self, from: json)
                            DispatchQueue.main.async {
                                success(decodedResponse)
                            }
                        } catch {
                            print(error)
                            failure(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    failure(error.errorDescription ?? "Something went wrong")
            }
        }
    }
    
    
    private static func makeXMLRequest<T>(url: URL, responseType: T.Type, success: @escaping((T) -> Void), failure: @escaping((String) -> Void)) where T : Codable{
        print("Making xml request to: \(String(describing: url.absoluteString))")
        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseString { response in
            switch response.result {
                case .success(let value):
                    let xml = value.data(using: .utf8)!
                    DispatchQueue(label: "parsing", qos: .userInitiated).async {
                        do {
                            let decodedResponse = try XMLDecoder().decode(T.self, from: xml)
                            DispatchQueue.main.async {
                                success(decodedResponse)
                            }
                        } catch {
                            print(error)
                            failure(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    failure(error.errorDescription ?? "Something went wrong")
            }
        }
    }
    
    static func makeStringRequest(url: URL, success: @escaping((String) -> ()), failure: @escaping((String) -> Void)) -> DataRequest{
        print("Making string request to: \(String(describing: url.absoluteString))")
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
