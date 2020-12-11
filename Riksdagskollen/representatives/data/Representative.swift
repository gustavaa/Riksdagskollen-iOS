//
//  Representative.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-17.
//

import Foundation

private let VIPRoles = ["Statsminister"]

class Representative: Codable {
    public var intressent_id: String
    public var sourceid: String
    public var fodd_ar: String
    public var kon: String
    public var efternamn: String
    public var tilltalsnamn: String
    public var parti: String
    public var valkrets: String
    public var status: String?
    public var bild_url_80: String
    public var bild_url_192: String
    public var bild_url_max: String
    public var personuppgift: RepresentativeInfoList?
    public var personuppdrag: RepresentativeMissionList?

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
    
    private var roleIsVIP: Bool {
        for role in VIPRoles {
            if status == role {
                return true
            }
        }
        return false
    }
    
    private var currentPartyRole: String? {
        guard let missions = personuppdrag?.uppdrag else { return nil}
        for mission in missions {
            if mission.typ == "partiuppdrag" && mission.tom == nil {
                if let status = mission.status {
                    return "\(status) \(mission.roll_kod)"
                } else {
                    return mission.roll_kod
                }
            }
        }
        return nil
    }
    
    private var currentOrMostRecentRole: String {
        guard let missions = personuppdrag?.uppdrag else { return "" }
        for mission in missions {
            if let _ = mission.tom {
                // Status can be "active" or "inactive" etc
                if let missionStatus = mission.status {
                    return "\(missionStatus) \(mission.roll_kod)"
                }
                return mission.roll_kod
            }
        }
        
        let mostRecentMission = missions.first
        if let missionStatus = mostRecentMission!.status {
            return "\(missionStatus) \(mostRecentMission!.roll_kod)"
        }
        return mostRecentMission!.roll_kod
    }
    
    var descriptiveRole: String {
        if roleIsVIP { return status! }
        if let partyRole = currentPartyRole { return partyRole }
        if let repStatus = status { return repStatus }
        return currentOrMostRecentRole
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


class RepresentativeMissionList: Codable {
    public var uppdrag: [RepresentativeMission]?
    
    enum CodingKeys: String, CodingKey {
        case uppdrag
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uppdrag = try? container.decodeIfPresent(Array<RepresentativeMission>.self, forKey: .uppdrag)
        if uppdrag == nil {
            if let singleStatement = try? container.decodeIfPresent(RepresentativeMission.self, forKey: .uppdrag) {
                uppdrag = [singleStatement]
            }
        }
    }
}

class RepresentativeMission: Codable {
    public var organ_kod: String
    public var roll_kod: String
    public var status: String?
    public var typ: String
    public var from: String
    public var tom: String?
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
