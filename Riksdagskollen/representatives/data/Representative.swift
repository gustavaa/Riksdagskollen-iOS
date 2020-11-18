//
//  Representative.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation


class Representative: Codable {
    public var intressent_id: String
    public var sourceid: String
    public var fodd_ar: String
    public var kon: String
    public var efternamn: String
    public var tilltalsnamn: String
    public var parti: String
    public var valkrets: String
    public var status: String
    public var bild_url_80: String
    public var bild_url_192: String
    public var bild_url_max: String
}
