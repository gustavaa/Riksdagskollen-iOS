//
//  VotesDocument.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-26.
//

import Foundation
class VotesDocument: PartyDocument {
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
    
    var voteResults: [String : [Int]]?
}
