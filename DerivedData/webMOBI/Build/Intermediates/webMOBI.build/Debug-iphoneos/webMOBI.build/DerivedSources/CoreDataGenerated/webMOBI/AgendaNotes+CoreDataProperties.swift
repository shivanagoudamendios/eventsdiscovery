//
//  AgendaNotes+CoreDataProperties.swift
//  
//
//  Created by webmobi on 10/1/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension AgendaNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgendaNotes> {
        return NSFetchRequest<AgendaNotes>(entityName: "AgendaNotes");
    }

    @NSManaged public var lastUpdated: Int64
    @NSManaged public var notesContent: String?
    @NSManaged public var notesDidAdd: Bool
    @NSManaged public var notesID: String?
    @NSManaged public var notesName: String?
    @NSManaged public var notesType: String?

}
