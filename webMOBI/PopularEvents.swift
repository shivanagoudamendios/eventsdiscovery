//
//  PopularEvents.swift
//  webMOBI
//
//  Created by webmobi on 5/25/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class getPopularEvents: NSObject,Mappable,NSCoding {
    
    
    required init?(map: Map) {
        
    }
    
    var appid : String? = ""
    var app_category : String? = ""
    var app_name : String? = ""
    var app_title : String? = ""
    var app_url : String? = ""
    var app_image : String? = ""
    var entry_fee : String? = ""
    var app_description : String? = ""
    var info_privacy : Int64? = 0
    var accesstype : String? = ""
    var start_date : String? = ""
    var end_date : String? = ""
    var venue : String? = ""
    var location : String? = ""
    var latitude : Double? = 0.0
    var longitude : Double? = 0.0
    var users : [AnyObject]? = [AnyObject]()
    var users_length : Int64? = 0
    
    init(appid : String, app_category : String, app_name : String, app_title : String, app_url : String, app_image : String, entry_fee : String, app_description : String, info_privacy : Int64, accesstype : String, start_date : String, end_date : String, venue : String, location : String, latitude : Double, longitude : Double, users : [AnyObject], users_length : Int64) {
        
        self.appid = appid
        self.app_category = app_category
        self.app_name = app_name
        self.app_title = app_title
        self.app_url = app_url
        self.app_image = app_image
        self.entry_fee = entry_fee
        self.app_description = app_description
        self.info_privacy = info_privacy
        self.accesstype = accesstype
        self.start_date = start_date
        self.end_date = end_date
        self.venue = venue
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.users = users
        self.users_length = users_length
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let appid = aDecoder.decodeObject(forKey: "appid"),
            let app_category = aDecoder.decodeObject(forKey: "app_category"),
            let app_name = aDecoder.decodeObject(forKey: "app_name"),
            let app_title = aDecoder.decodeObject(forKey: "app_title"),
            let app_url = aDecoder.decodeObject(forKey: "app_url"),
            let app_image = aDecoder.decodeObject(forKey: "app_image"),
            let entry_fee = aDecoder.decodeObject(forKey: "entry_fee"),
            let app_description = aDecoder.decodeObject(forKey: "app_description"),
            let info_privacy = aDecoder.decodeObject(forKey: "info_privacy"),
            let accesstype = aDecoder.decodeObject(forKey: "accesstype"),
            let start_date = aDecoder.decodeObject(forKey: "start_date"),
            let end_date = aDecoder.decodeObject(forKey: "end_date"),
            let venue = aDecoder.decodeObject(forKey: "venue"),
            let location = aDecoder.decodeObject(forKey: "location"),
            let latitude = aDecoder.decodeObject(forKey: "latitude"),
            let longitude = aDecoder.decodeObject(forKey: "longitude"),
            let users = aDecoder.decodeObject(forKey: "users"),
            let users_length = aDecoder.decodeObject(forKey: "users_length")
            
            else{
                return nil
        }
        
        self.init(appid: appid as! String, app_category: app_category as! String, app_name: app_name as! String, app_title: app_title as! String, app_url: app_url as! String, app_image: app_image as! String, entry_fee: entry_fee as! String, app_description: app_description as! String, info_privacy: info_privacy as! Int64, accesstype: accesstype as! String, start_date: start_date as! String, end_date: end_date as! String, venue: venue as! String, location: location as! String, latitude: latitude as! Double, longitude: longitude as! Double, users: users as! [AnyObject], users_length: users_length as! Int64 )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(appid, forKey: "appid")
        aCoder.encode(app_category, forKey: "app_category")
        aCoder.encode(app_name, forKey: "app_name")
        aCoder.encode(app_title, forKey: "app_title")
        aCoder.encode(app_url, forKey: "app_url")
        aCoder.encode(app_image, forKey: "app_image")
        aCoder.encode(entry_fee, forKey: "entry_fee")
        aCoder.encode(app_description, forKey: "app_description")
        aCoder.encode(info_privacy, forKey: "info_privacy")
        aCoder.encode(accesstype, forKey: "accesstype")
        aCoder.encode(start_date, forKey: "start_date")
        aCoder.encode(end_date, forKey: "end_date")
        aCoder.encode(venue, forKey: "venue")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(users, forKey: "users")
        aCoder.encode(users_length, forKey: "users_length")
        
    }
    
    // Mappable
    func mapping(map: Map) {
        appid <- map["appid"]
        app_category <- map["app_category"]
        app_name <- map["app_name"]
        app_title <- map["app_title"]
        app_url <- map["app_url"]
        app_image <- map["app_image"]
        entry_fee <- map["entry_fee"]
        app_description <- map["app_description"]
        info_privacy <- map["info_privacy"]
        accesstype <- map["accesstype"]
        start_date <- map["start_date"]
        end_date <- map["end_date"]
        venue <- map["venue"]
        location <- map["location"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        users <- map["users"]
        users_length <- map["users_length"]
        
    }
    func toAnyObject() -> Any {
        return [
            "appid" :  appid,
            "app_category" :  app_category,
            "app_name" :  app_name,
            "app_title" :  app_title,
            "app_url" :  app_url,
            "app_image" :  app_image,
            "entry_fee" :  entry_fee,
            "app_description" :  app_description,
            "info_privacy" :  info_privacy,
            "accesstype" :  accesstype,
            "start_date" :  start_date,
            "end_date" :  end_date,
            "venue" :  venue,
            "location" :  location,
            "latitude" :  latitude,
            "longitude" :  longitude,
            "users" :  users,
            "users_length" :  users_length
        ]
    }
}

class getJoinedPeoples: NSObject,Mappable,NSCoding {
    
    
    required init?(map: Map) {
        
    }
    
    var profile_pic : String? = ""
    var userid : String? = ""
    var first_name : String? = ""
    var last_name : String? = ""
    var company : String? = ""
    var designation : String? = ""
    var email : String? = ""
    
    init(profile_pic : String, userid : String, first_name : String, last_name : String, company : String, designation : String, email : String) {
        
        self.profile_pic = profile_pic
        self.userid = userid
        self.first_name = first_name
        self.last_name = last_name
        self.company = company
        self.designation = designation
        self.email = email
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let profile_pic = aDecoder.decodeObject(forKey: "profile_pic"),
            let userid = aDecoder.decodeObject(forKey: "userid"),
            let first_name = aDecoder.decodeObject(forKey: "first_name"),
            let last_name = aDecoder.decodeObject(forKey: "last_name"),
            let company = aDecoder.decodeObject(forKey: "company"),
            let designation = aDecoder.decodeObject(forKey: "designation"),
            let email = aDecoder.decodeObject(forKey: "email")
            
            else{
                return nil
        }
        
        self.init(profile_pic: profile_pic as! String, userid: userid as! String, first_name: first_name as! String, last_name: last_name as! String, company: company as! String, designation: designation as! String, email: email as! String)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(profile_pic, forKey: "profile_pic")
        aCoder.encode(userid, forKey: "userid")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(company, forKey: "company")
        aCoder.encode(designation, forKey: "designation")
        aCoder.encode(email, forKey: "email")
        
    }
    
    // Mappable
    func mapping(map: Map) {
        profile_pic <- map["profile_pic"]
        userid <- map["userid"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        company <- map["company"]
        designation <- map["designation"]
        email <- map["email"]
        
    }
}
