//
//  RepresentativeMissionList+CoreDataProperties.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData



extension RepresentativeMissionList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepresentativeMissionList> {
        return NSFetchRequest<RepresentativeMissionList>(entityName: "RepresentativeMissionList")
    }

    @NSManaged public var uppdrag: Set<RepresentativeMission>?

}

// MARK: Generated accessors for uppdrag
extension RepresentativeMissionList {

    @objc(addUppdragObject:)
    @NSManaged public func addToUppdrag(_ value: RepresentativeMission)

    @objc(removeUppdragObject:)
    @NSManaged public func removeFromUppdrag(_ value: RepresentativeMission)

    @objc(addUppdrag:)
    @NSManaged public func addToUppdrag(_ values: NSSet)

    @objc(removeUppdrag:)
    @NSManaged public func removeFromUppdrag(_ values: NSSet)

}
