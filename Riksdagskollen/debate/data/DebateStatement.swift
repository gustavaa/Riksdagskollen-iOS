//
//  DebateStatement.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation


class DebateStatement: Codable {
    public var parti: String
    public var anf_nummer: String
    public var anf_datumtid: String
    public var intressent_id: String
    public var talare: String
    public var anf_klockslag: String
    public var tumnagel: String
    public var video_url: String
    public var anf_sekunder: String
    //public var speech: Speech
    //public var webTVUrl: String
}
