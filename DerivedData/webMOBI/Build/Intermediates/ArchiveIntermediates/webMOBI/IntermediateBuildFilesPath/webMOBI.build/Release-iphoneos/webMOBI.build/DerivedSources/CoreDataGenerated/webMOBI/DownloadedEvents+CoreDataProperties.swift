//
//  DownloadedEvents+CoreDataProperties.swift
//  
//
//  Created by webmobi on 8/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension DownloadedEvents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DownloadedEvents> {
        return NSFetchRequest<DownloadedEvents>(entityName: "DownloadedEvents");
    }

    @NSManaged public var appid: String?
    @NSManaged public var isfirstlogin: Bool
    @NSManaged public var password: String?

}