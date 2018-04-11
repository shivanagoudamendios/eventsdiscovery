//
//  SpeakersRatings+CoreDataProperties.swift
//  
//
//  Created by webmobi on 10/1/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SpeakersRatings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpeakersRatings> {
        return NSFetchRequest<SpeakersRatings>(entityName: "SpeakersRatings");
    }

    @NSManaged public var appid: String?
    @NSManaged public var rating: Int16
    @NSManaged public var rating_id: String?
    @NSManaged public var rating_type: String?
    @NSManaged public var type_id: String?
    @NSManaged public var userid: String?

}
