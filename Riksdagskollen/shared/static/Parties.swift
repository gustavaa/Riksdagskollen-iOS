//
//  Parties.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation
import UIKit

struct Party: Equatable {
    var id: String
    var name: String
    var website: String
    var ideology: String
    var logo: UIImage
    var wikiUrl: String
    
    static func == (lhs: Party, rhs: Party) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CurrentParties {
    static let M = Party(id: "m", name: "Moderaterna", website: "www.moderaterna.se", ideology: "", logo: UIImage(named: "mlogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Moderaterna")
    static let S = Party(id: "s", name: "Socialdemokraterna", website: "www.socialdemokraterna.se", ideology: "", logo: UIImage(named: "slogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Socialdemokraterna_(Sverige)")
    static let SD = Party(id: "sd", name: "Sverigedemokraterna", website: "wwww.sd.se", ideology: "", logo: UIImage(named: "sdlogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Sverigedemokraterna")
    static let C = Party(id: "c", name: "Centerpartiet", website: "www.centerpartiet.se", ideology: "", logo: UIImage(named: "clogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Centerpartiet")
    static let V = Party(id: "v", name: "Vänsterpartiet", website: "www.vansterpartiet.se", ideology: "", logo: UIImage(named: "vlogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/V%C3%A4nsterpartiet")
    static let KD = Party(id: "kd", name: "Kristdemokraterna", website: "www.kristdemokraterna.se", ideology: "", logo: UIImage(named: "kdlogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Kristdemokraterna_(Sverige)")
    static let MP = Party(id: "mp", name: "Miljöpartiet", website: "www.mp.se", ideology: "", logo: UIImage(named: "mplogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Milj%C3%B6partiet")
    static let L = Party(id: "l", name: "Liberalerna", website: "www.liberalerna.se", ideology: "", logo: UIImage(named: "llogo")!, wikiUrl: "https://sv.wikipedia.org/wiki/Liberalerna")
    static let noParty = Party(id: "-", name: "Politiska Vildar", website: "", ideology: "", logo: UIImage(), wikiUrl: "")
    static let values = [M, S, SD, C, V, KD, MP, L, noParty]
    
    static func getParty(id: String) -> Party?{
        if let party = values.first(where: { $0.id == id.lowercased() }) {
            return party
        }
        return OtherParties.getParty(id: id)
    }
}

struct OtherParties {
    static let FP = Party(id: "fp", name: "Folkpartiet", website: "", ideology: "", logo: UIImage(), wikiUrl: "")
    static let values = [FP]
    
    static func getParty(id: String) -> Party?{
        return values.first(where: { $0.id  == id.lowercased() })
    }
}
