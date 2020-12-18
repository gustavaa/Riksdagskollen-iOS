//
//  Representative+CoreDataClass.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}


@objc(Representative)
public class Representative: NSManagedObject, Codable {

    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(intressent_id ?? "blank", forKey: .intressent_id)
        } catch {
            print("error")
        }
    }
    
    required convenience public init(from decoder: Decoder) throws {
        // return the context from the decoder userinfo dictionary
        guard let contextUserInfoKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "Representative", in: managedObjectContext)
        else {
            fatalError("decode failure")
        }
        // Super init of the NSManagedObject
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            intressent_id = try values.decode(String.self, forKey: .intressent_id)
            sourceid = try values.decode(String.self, forKey: .sourceid)
            fodd_ar = try values.decode(String.self, forKey: .fodd_ar)
            kon = try values.decode(String.self, forKey: .kon)
            efternamn = try values.decode(String.self, forKey: .efternamn)
            tilltalsnamn = try values.decode(String.self, forKey: .tilltalsnamn)
            parti = try values.decode(String.self, forKey: .parti)
            valkrets = try values.decode(String.self, forKey: .valkrets)
            status = try values.decode(String.self, forKey: .status)
            bild_url_80 = try values.decode(String.self, forKey: .bild_url_80)
            bild_url_192 = try values.decode(String.self, forKey: .bild_url_192)
            bild_url_max = try values.decode(String.self, forKey: .bild_url_max)
            bild_url_max = try values.decode(String.self, forKey: .bild_url_max)
            personuppgift = try values.decode(RepresentativeInfoList.self, forKey: .personuppgift)
            personuppdrag = try values.decode(RepresentativeMissionList.self, forKey: .personuppdrag)

        } catch let error {
            print ("error decoding Representative: \(error.localizedDescription)")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case intressent_id
        case sourceid
        case fodd_ar
        case kon
        case efternamn
        case tilltalsnamn
        case parti
        case valkrets
        case status
        case bild_url_80
        case bild_url_192
        case bild_url_max
        case personuppgift
        case personuppdrag
    }
    
}

