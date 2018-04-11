//
//  SponsorsFavorites+CoreDataProperties.swift
//  
//
//  Created by webmobi on 10/3/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SponsorsFavorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SponsorsFavorites> {
        return NSFetchRequest<SponsorsFavorites>(entityName: "SponsorsFavorites");
    }

    @NSManaged public var eventid: Int64
    @NSManaged public var id: String?

}
