//
//  RepresentativeInfo+CoreDataProperties.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData


extension RepresentativeInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepresentativeInfo> {
        return NSFetchRequest<RepresentativeInfo>(entityName: "RepresentativeInfo")
    }

    @NSManaged public var kod: String?
    @NSManaged public var uppgift: Array<String>?
    @NSManaged public var typ: String?
    @NSManaged public var intressent_id: String?
    @NSManaged public var hangar_id: String?

}
