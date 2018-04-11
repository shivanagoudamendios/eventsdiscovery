//
//  ExhibitorFavorites+CoreDataProperties.swift
//  
//
//  Created by webmobi on 8/3/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ExhibitorFavorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExhibitorFavorites> {
        return NSFetchRequest<ExhibitorFavorites>(entityName: "ExhibitorFavorites");
    }

    @NSManaged public var eventid: Int64
    @NSManaged public var id: String?

}
