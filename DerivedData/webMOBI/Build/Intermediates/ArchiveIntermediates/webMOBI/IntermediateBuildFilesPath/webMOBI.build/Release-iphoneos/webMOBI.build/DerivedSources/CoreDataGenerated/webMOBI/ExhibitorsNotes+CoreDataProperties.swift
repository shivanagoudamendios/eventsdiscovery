//
//  ExhibitorsNotes+CoreDataProperties.swift
//  
//
//  Created by webmobi on 8/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ExhibitorsNotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExhibitorsNotes> {
        return NSFetchRequest<ExhibitorsNotes>(entityName: "ExhibitorsNotes");
    }

    @NSManaged public var lastUpdated: Int64
    @NSManaged public var notesContent: String?
    @NSManaged public var notesDidAdd: Bool
    @NSManaged public var notesID: String?
    @NSManaged public var notesName: String?
    @NSManaged public var notesType: String?

}
