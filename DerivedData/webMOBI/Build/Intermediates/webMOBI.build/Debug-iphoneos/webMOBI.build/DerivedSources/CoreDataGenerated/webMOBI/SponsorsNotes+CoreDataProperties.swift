//
//  SponsorsNotes+CoreDataProperties.swift
//  
//
//  Created by webmobi on 10/1/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SponsorsNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SponsorsNotes> {
        return NSFetchRequest<SponsorsNotes>(entityName: "SponsorsNotes");
    }

    @NSManaged public var lastUpdated: Int64
    @NSManaged public var notesContent: String?
    @NSManaged public var notesDidAdd: Bool
    @NSManaged public var notesID: String?
    @NSManaged public var notesName: String?
    @NSManaged public var notesType: String?

}
