//
//  RepresentativeInfoList+CoreDataClass.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

@objc(RepresentativeInfoList)
public class RepresentativeInfoList: NSManagedObject, Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(uppgift ?? nil, forKey: .uppgift)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "RepresentativeInfoList", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uppgift = Set(try values.decodeIfPresent([RepresentativeInfo].self, forKey: .uppgift) ?? [])
        if uppgift == nil {
            if let singleStatement = try? values.decodeIfPresent(RepresentativeInfo.self, forKey: .uppgift) {
                uppgift = [singleStatement]
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case uppgift
    }

}
