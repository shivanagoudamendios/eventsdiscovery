//
//  AgendaRatings+CoreDataProperties.swift
//  
//
//  Created by webmobi on 8/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension AgendaRatings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AgendaRatings> {
        return NSFetchRequest<AgendaRatings>(entityName: "AgendaRatings");
    }

    @NSManaged public var appid: String?
    @NSManaged public var rating: Int16
    @NSManaged public var rating_id: String?
    @NSManaged public var rating_type: String?
    @NSManaged public var type_id: String?
    @NSManaged public var userid: String?

}
