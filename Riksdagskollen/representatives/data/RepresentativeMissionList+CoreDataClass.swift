//
//  RepresentativeMissionList+CoreDataClass.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

@objc(RepresentativeMissionList)
public class RepresentativeMissionList: NSManagedObject, Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(uppdrag ?? nil, forKey: .uppdrag)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "RepresentativeMissionList", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uppdrag = Set(try values.decodeIfPresent([RepresentativeMission].self, forKey: .uppdrag) ?? [])
        if uppdrag == nil {
            if let singleStatement = try? values.decodeIfPresent(RepresentativeMission.self, forKey: .uppdrag) {
                uppdrag = [singleStatement]
            }
        }
   
    }
    
    enum CodingKeys: String, CodingKey {
        case uppdrag
    }

}
