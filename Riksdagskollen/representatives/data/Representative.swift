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
    public var personuppgift: RepresentativeInfoList?
    
    public var title: String? {
        guard let infoList = personuppgift, let infoArray = infoList.uppgift else { return nil }
        for info in infoArray {
            if info.kod == "sv" {
                return info.uppgift?[0]
            }
        }
        return nil
    }
    
    public var age: Int? {
        if let bithYear = Int(fodd_ar) {
            return Calendar.current.component(.year, from: Date()) - bithYear
        }
        return nil
    }

}

class RepresentativeInfoList: Codable {
    public var uppgift: [RepresentativeInfo]?
    
    enum CodingKeys: String, CodingKey {
        case uppgift
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uppgift = try? container.decodeIfPresent(Array<RepresentativeInfo>.self, forKey: .uppgift)
        if uppgift == nil {
            if let singleStatement = try? container.decodeIfPresent(RepresentativeInfo.self, forKey: .uppgift) {
                uppgift = [singleStatement]
            }
        }
    }
    
}

class RepresentativeInfo: Codable {
    public var kod: String?
    public var uppgift: [String]?
    public var typ: String?
    public var intressent_id: String?
    public var hangar_id: String?
    
    enum CodingKeys: String, CodingKey {
        case kod
        case uppgift
        case typ
        case intressent_id
        case hangar_id
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kod = try? container.decodeIfPresent(String.self, forKey: .kod)
        typ = try? container.decodeIfPresent(String.self, forKey: .typ)
        intressent_id = try? container.decodeIfPresent(String.self, forKey: .intressent_id)
        hangar_id = try? container.decodeIfPresent(String.self, forKey: .hangar_id)
        uppgift = try? container.decodeIfPresent(Array<String>.self, forKey: .uppgift)
    }
}
