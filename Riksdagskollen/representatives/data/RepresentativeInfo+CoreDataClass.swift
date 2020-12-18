//
//  RepresentativeInfo+CoreDataClass.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

@objc(RepresentativeInfo)
public class RepresentativeInfo: NSManagedObject, Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(hangar_id ?? "blank", forKey: .hangar_id)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "RepresentativeInfo", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kod = try? values.decode(String.self, forKey: .kod)
        uppgift = try? values.decode(Array<String>.self, forKey: .uppgift)
        intressent_id = try? values.decode(String.self, forKey: .intressent_id)
        typ = try? values.decode(String.self, forKey: .typ)
        hangar_id = try? values.decode(String.self, forKey: .hangar_id)
    }
    
    enum CodingKeys: String, CodingKey {
        case kod
        case uppgift
        case typ
        case intressent_id
        case hangar_id
    }
    
    

}
