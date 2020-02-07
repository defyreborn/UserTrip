//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Mubashshir on 2/7/20.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var speed: Double
    @NSManaged public var time: Date?

}
