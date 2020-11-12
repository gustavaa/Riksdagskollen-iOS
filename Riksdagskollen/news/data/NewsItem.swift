//
//  NewsItem.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-08.
//

import Foundation

struct NewsResult: Codable {
    public var dokumentlista: NewsResponse
    
    struct NewsResponse: Codable {
        public var dokument: [NewsItem]
    }
}

struct NewsItem: Codable {
    public var id: String
    public var titel: String
    public var publicerad: String
    public var summary: String
    public var url: String
    public var img_url: String
    public var img_fotograf: String
    public var img_text: String
    public var img_tumnagel_url: String
    public var linklista: LinkLista?
    
    
    public func getNewsUrl() -> String {
        var newsURL = ""
        
        if let linkListaUrl = self.linklista?.link?.url {
            newsURL = linkListaUrl
        } else {
            newsURL = url
        }
        
        if newsURL.hasPrefix("http") {
            return newsURL
        } else {
            return "https://riksdagen.se\(newsURL)"
        }
    }
    
    public func getImageUrl() -> String? {
        if !img_url.isEmpty {
            return "https://riksdagen.se\(img_url)"
        } else {
            return nil
        }
    }
    
    public func hasImage() -> Bool {
        return getImageUrl() != nil
    }
}

class LinkLista: Codable {
    public var link: NewsLink?
    
    enum CodingKeys: String, CodingKey {
        case link
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try? container.decodeIfPresent(NewsLink.self, forKey: .link)
        if link == nil {
            if let array = try? container.decodeIfPresent(Array<NewsLink>.self, forKey: .link) {
                link = array[0]
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}

class NewsLink: Codable {
    public var url: String?
    
    
}
