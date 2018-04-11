//
//  ScheduleFavorites+CoreDataProperties.swift
//  
//
//  Created by webmobi on 10/3/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ScheduleFavorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleFavorites> {
        return NSFetchRequest<ScheduleFavorites>(entityName: "ScheduleFavorites");
    }

    @NSManaged public var eventid: Int64
    @NSManaged public var id: String?

}
