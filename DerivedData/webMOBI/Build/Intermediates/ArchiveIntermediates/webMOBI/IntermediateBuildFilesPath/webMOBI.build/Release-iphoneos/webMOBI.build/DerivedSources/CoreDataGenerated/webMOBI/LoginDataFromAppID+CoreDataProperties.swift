//
//  LoginDataFromAppID+CoreDataProperties.swift
//  
//
//  Created by webmobi on 8/14/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension LoginDataFromAppID {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LoginDataFromAppID> {
        return NSFetchRequest<LoginDataFromAppID>(entityName: "LoginDataFromAppID");
    }

    @NSManaged public var appid: String?
    @NSManaged public var data: NSData?

}
