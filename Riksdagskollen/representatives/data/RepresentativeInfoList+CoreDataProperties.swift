//
//  RepresentativeInfoList+CoreDataProperties.swift
//  
//
//  Created by Gustav Aaro on 2020-12-17.
//
//

import Foundation
import CoreData

extension RepresentativeInfoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepresentativeInfoList> {
        return NSFetchRequest<RepresentativeInfoList>(entityName: "RepresentativeInfoList")
    }

    @NSManaged public var uppgift: Set<RepresentativeInfo>?
    

}

// MARK: Generated accessors for uppdrag
extension RepresentativeInfoList {

    @objc(addUppdragObject:)
    @NSManaged public func addToUppdrag(_ value: RepresentativeInfoList)

    @objc(removeUppdragObject:)
    @NSManaged public func removeFromUppdrag(_ value: RepresentativeInfoList)

    @objc(addUppdrag:)
    @NSManaged public func addToUppdrag(_ values: NSSet)

    @objc(removeUppdrag:)
    @NSManaged public func removeFromUppdrag(_ values: NSSet)

}
