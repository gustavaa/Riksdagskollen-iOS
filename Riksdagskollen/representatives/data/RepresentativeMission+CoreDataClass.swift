//
//  RepresentativeMission+CoreDataClass.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

@objc(RepresentativeMission)
public class RepresentativeMission: NSManagedObject, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(organ_kod ?? "blank", forKey: .organ_kod)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "RepresentativeMission", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            organ_kod = try values.decode(String.self, forKey: .organ_kod)
            roll_kod = try values.decode(String.self, forKey: .roll_kod)
            status = try values.decode(String.self, forKey: .status)
            typ = try values.decode(String.self, forKey: .typ)
            from = try values.decode(String.self, forKey: .from)
            tom = try values.decode(String.self, forKey: .tom)

        } catch let error{
            print ("error decoding RepresentativeMission: \(error.localizedDescription)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
       case organ_kod
       case roll_kod
       case status
       case typ
       case from
       case tom
    }
}
