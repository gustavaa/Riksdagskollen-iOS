//
//  DecisionDocument.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-13.
//

import Foundation
import UIKit

struct DecisionDocument: Codable {
    public var dok_id: String
    public var notisrubrik: String
    public var publicerad: String
    public var notis: String
    public var beslutsdag: String
    public var debattdag: String
    public var justeringsdag: String
    public var dokument_url_html: String
    public var titel: String
    public var datum: String
    public var rm: String
    public var beteckning: String
    
    enum CodingKeys: String, CodingKey {
        case dok_id
        case notisrubrik
        case publicerad
        case notis
        case beslutsdag
        case debattdag
        case justeringsdag
        case dokument_url_html
        case titel
        case datum
        case rm
        case beteckning
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dok_id = try values.decode(String.self, forKey: .dok_id)
        notisrubrik = try values.decode(String.self, forKey: .notisrubrik)
        publicerad = try values.decode(String.self, forKey: .publicerad)
        notis = try values.decode(String.self, forKey: .notis)
        beslutsdag = try values.decode(String.self, forKey: .beslutsdag)
        debattdag = try values.decode(String.self, forKey: .debattdag)
        justeringsdag = try values.decode(String.self, forKey: .justeringsdag)
        dokument_url_html = try values.decode(String.self, forKey: .dokument_url_html)
        titel = try values.decode(String.self, forKey: .titel)
        datum = try values.decode(String.self, forKey: .datum)
        rm = try values.decode(String.self, forKey: .rm)
        beteckning = try values.decode(String.self, forKey: .beteckning)
    }
    
    
    public var hasVotes = false
    public var isExpanded = false
    public var initialHeight: CGFloat = 0
}
