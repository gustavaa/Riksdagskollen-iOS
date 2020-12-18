//
//  RepresentativeMission+CoreDataProperties.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData


extension RepresentativeMission {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepresentativeMission> {
        return NSFetchRequest<RepresentativeMission>(entityName: "RepresentativeMission")
    }

    @NSManaged public var organ_kod: String?
    @NSManaged public var roll_kod: String?
    @NSManaged public var status: String?
    @NSManaged public var typ: String?
    @NSManaged public var from: String?
    @NSManaged public var tom: String?

}
