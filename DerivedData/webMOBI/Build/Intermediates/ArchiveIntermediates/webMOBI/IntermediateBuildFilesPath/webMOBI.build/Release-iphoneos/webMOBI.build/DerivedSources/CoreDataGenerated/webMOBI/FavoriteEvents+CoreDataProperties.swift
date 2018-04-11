//
//  FavoriteEvents+CoreDataProperties.swift
//  
//
//  Created by webmobi on 8/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FavoriteEvents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEvents> {
        return NSFetchRequest<FavoriteEvents>(entityName: "FavoriteEvents");
    }

    @NSManaged public var accesstype: String?
    @NSManaged public var app_category: String?
    @NSManaged public var app_description: String?
    @NSManaged public var app_image: String?
    @NSManaged public var app_name: String?
    @NSManaged public var app_title: String?
    @NSManaged public var app_url: String?
    @NSManaged public var appid: String?
    @NSManaged public var end_date: String?
    @NSManaged public var entry_fee: String?
    @NSManaged public var info_privacy: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var location: String?
    @NSManaged public var longitude: Double
    @NSManaged public var start_date: String?
    @NSManaged public var users: NSObject?
    @NSManaged public var users_length: Int64
    @NSManaged public var venue: String?

}
