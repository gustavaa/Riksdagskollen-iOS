//
//  Debate.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation

class Debate: Codable {
    public var anforande: [DebateStatement]?
        
    func getPartiesInDebate() -> [Party] {
        var parties: [Party] = []
        anforande?.forEach() { anf in
            let party = CurrentParties.getParty(id: anf.parti)
            if party != nil  && !parties.contains(party!){
                parties.append(party!)
            }
        }
        return parties
    }
        
    enum CodingKeys: String, CodingKey {
        case anforande
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        anforande = try? container.decodeIfPresent(Array<DebateStatement>.self, forKey: .anforande)
        if anforande == nil {
            if let singleStatement = try? container.decodeIfPresent(DebateStatement.self, forKey: .anforande) {
                anforande = [singleStatement]
            }
        }
    }
}
