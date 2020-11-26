//
//  PartyDocument.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation

class PartyDocument: Codable {
    public var id: String
    public var undertitel: String
    public var titel: String
    public var rm: String
    public var typ: String
    public var beteckning: String
    public var publicerad: String
    public var doktyp: String
    public var dokument_url_html: String
    public var dokument_url_text: String
    public var traff: String
    public var summary: String
    public var dokumentnamn: String
    public var datum: String
    public var debatt: Debate?
    public var dokintressent: DocIntressent?
    public var debattnamn: String
    public var debattdag: String
    
    
    func getSenders() -> [String] {
        if let intressents = dokintressent?.intressent {
            var senders: [String] = []
            for intressent in intressents {
                if intressent.roll == "undertecknare" || (doktyp == "frs" && intressent.roll == "besvaradav") {
                    senders.append(intressent.intressent_id)
                }
            }
            return senders
        }
        return []
    }
}

class DocIntressent: Codable {
    public var intressent: [Intressent]
}

class Intressent: Codable {
    public var roll: String
    public var namn: String
    public var intressent_id: String
    public var partibet: String
}
