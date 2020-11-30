//
//  VotesDocument.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import Foundation
class VotingDocument: PartyDocument {
    
    var organ: String
    var nummer: String

    enum CodingKeys: String, CodingKey {
        case organ
        case nummer
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        organ = try values.decode(String.self, forKey: .organ)
        nummer = try values.decode(String.self, forKey: .nummer)
        try super.init(from: decoder)
    }
    
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    var searchableBetId: String {
        let yearCode = id.prefix(2)
        let documentType = "01" // Betänkande
        return yearCode + documentType + organ + nummer
    }
    
    var voteResults: [String : [Int]]?
    var votingHtmlContent: String?
}
