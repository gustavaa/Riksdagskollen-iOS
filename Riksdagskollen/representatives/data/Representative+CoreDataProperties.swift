//
//  Representative+CoreDataProperties.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

private let VIPRoles = ["Statsminister"]

extension Representative {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Representative> {
        return NSFetchRequest<Representative>(entityName: "Representative")
    }

    @NSManaged public var intressent_id: String
    @NSManaged public var status: String?
    @NSManaged public var valkrets: String
    @NSManaged public var parti: String
    @NSManaged public var tilltalsnamn: String
    @NSManaged public var efternamn: String
    @NSManaged public var kon: String?
    @NSManaged public var fodd_ar: String
    @NSManaged public var sourceid: String
    @NSManaged public var bild_url_max: String
    @NSManaged public var bild_url_192: String
    @NSManaged public var bild_url_80: String
    @NSManaged public var personuppgift: RepresentativeInfoList?
    @NSManaged public var personuppdrag: RepresentativeMissionList?
    
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
        if let birthYear = Int(fodd_ar) {
            return Calendar.current.component(.year, from: Date()) - birthYear
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
            if mission.typ == "partiuppdrag" && (mission.tom == nil || mission.tom?.isEmpty == true) {
                if let status = mission.status {
                    return "\(status) \(mission.roll_kod)"
                } else {
                    return mission.roll_kod
                }
            }
        }
        return nil
    }
    
    private var currentOrMostRecentRole: String? {
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
    
    var descriptiveRole: String? {
        if roleIsVIP { return status! }
        if let partyRole = currentPartyRole { return partyRole }
        if let repStatus = status { return repStatus }
        if let role = currentOrMostRecentRole { return role }
        return ""
    }
    
    var biography: [[String]] {
        var biography = [[String]]()
        if let personInfo = personuppgift?.uppgift {
            for info in personInfo {
                if info.typ == "biografi", let kod = info.kod, let task = info.uppgift{
                    biography.append([kod, task[0]])
                }
            }
        }
        return biography
    }
    
    var website: String? {
        if let infoList = personuppgift?.uppgift {
            for info in infoList {
                if info.kod == "Webbsida" {
                    return info.uppgift![safe: 0]
                }
            }
        }
        return nil
    }

}
