//
//  LoginObject.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/29/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var exhibitor_favorites : [Int64] = []
    var notes : Notes?
    var ratings : Ratings?
    var schedules  : [Int64] = []
    var sponsor_favorites : [Int64] = []
    var token : Token?
    
    
    
    required init?(map: Map) {
        
    }
    
    
    init(exhibitor_favorites: [Int64], notes: Notes,ratings: Ratings,schedules: [Int64],sponsor_favorites: [Int64],token: Token) {
        self.exhibitor_favorites = exhibitor_favorites
        self.notes = notes
        self.ratings = ratings
        self.schedules = schedules
        self.sponsor_favorites = sponsor_favorites
        self.token = token
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let exhibitor_favorites = aDecoder.decodeObject(forKey: "exhibitor_favorites"),
            let notes = aDecoder.decodeObject(forKey: "notes"),
            let ratings = aDecoder.decodeObject(forKey: "ratings"),
            let schedules = aDecoder.decodeObject(forKey: "schedules"),
            let sponsor_favorites = aDecoder.decodeObject(forKey: "sponsor_favorites"),
            let token = aDecoder.decodeObject(forKey: "token")
            else{
                return nil
        }
        self.init(exhibitor_favorites: exhibitor_favorites as! [Int64], notes: notes as! Notes,ratings: ratings as! Ratings,schedules: schedules as! [Int64],sponsor_favorites: sponsor_favorites as! [Int64],token: token as! Token)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(exhibitor_favorites,     forKey: "exhibitor_favorites")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(ratings, forKey: "ratings")
        aCoder.encode(schedules, forKey: "schedules")
        aCoder.encode(sponsor_favorites, forKey: "sponsor_favorites")
        aCoder.encode(token, forKey: "token")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        exhibitor_favorites <- map["exhibitor_favorites"]
        notes <- map["notes"]
        ratings <- map["ratings"]
        schedules <- map["schedules"]
        sponsor_favorites <- map["sponsor_favorites"]
        token <- map["token"]
    }
}


class Notes: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var agenda : [NotesResponse] = []
    var exhibitors : [NotesResponse] = []
    var sponsors : [NotesResponse] = []
    
    
    
    required init?(map: Map) {
        
    }
    
    
    init(agenda: [NotesResponse], exhibitors: [NotesResponse],sponsors: [NotesResponse]) {
        self.agenda = agenda
        self.exhibitors = exhibitors
        self.sponsors = sponsors
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let agenda = aDecoder.decodeObject(forKey: "agenda"),
            let exhibitors = aDecoder.decodeObject(forKey: "exhibitors"),
            let sponsors = aDecoder.decodeObject(forKey: "sponsors")
            else{
                return nil
        }
        self.init(agenda: agenda as! [NotesResponse], exhibitors: exhibitors as! [NotesResponse],sponsors: sponsors as! [NotesResponse])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(agenda,     forKey: "agenda")
        aCoder.encode(exhibitors, forKey: "exhibitors")
        aCoder.encode(sponsors, forKey: "sponsors")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        agenda <- map["agenda"]
        exhibitors <- map["exhibitors"]
        sponsors <- map["sponsors"]
    }
}

class NotesResponse: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var id : Int64? = 0
    var last_updated : Int64? = 0
    var name : String? = ""
    var notes  : String? = ""
    var type : String? = ""
    
    
    
    required init?(map: Map) {
        
    }
    
    
    init(id: Int64, last_updated: Int64,name: String,notes: String,type: String) {
        self.id = id
        self.last_updated = last_updated
        self.name = name
        self.notes = notes
        self.type = type
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id"),
            let last_updated = aDecoder.decodeObject(forKey: "last_updated"),
            let name = aDecoder.decodeObject(forKey: "name"),
            let notes = aDecoder.decodeObject(forKey: "notes"),
            let type = aDecoder.decodeObject(forKey: "type")
            else{
                return nil
        }
        self.init(id: id as! Int64, last_updated: last_updated as! Int64,name: name as! String,notes: notes as! String,type: type as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(id,     forKey: "id")
        aCoder.encode(last_updated, forKey: "last_updated")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(type, forKey: "type")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        last_updated <- map["last_updated"]
        name <- map["name"]
        notes <- map["notes"]
        type <- map["type"]
    }
}

class Ratings: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var agenda : [RatingsResponse] = []
    var speakers : [RatingsResponse] = []
    
    
    
    required init?(map: Map) {
        
    }
    
    
    init(agenda: [RatingsResponse], speakers: [RatingsResponse]) {
        self.agenda = agenda
        self.speakers = speakers
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let agenda = aDecoder.decodeObject(forKey: "agenda"),
            let speakers = aDecoder.decodeObject(forKey: "speakers")
            else{
                return nil
        }
        self.init(agenda: agenda as! [RatingsResponse], speakers: speakers as! [RatingsResponse])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(agenda,     forKey: "agenda")
        aCoder.encode(speakers, forKey: "speakers")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        agenda <- map["agenda"]
        speakers <- map["speakers"]
    }
}

class RatingsResponse: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var appid : String? = ""
    var rating : Double? = 0
    var rating_id : String? = ""
    var rating_type  : String? = ""
    var type_id : Int64? = 0
    var userid : String? = ""
    
    
    
    required init?(map: Map) {
        
    }
    
    
    init(appid: String, rating: Double,rating_id: String,rating_type: String,type_id: Int64,userid: String) {
        self.appid = appid
        self.rating = rating
        self.rating_id = rating_id
        self.rating_type = rating_type
        self.type_id = type_id
        self.userid = userid
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let appid = aDecoder.decodeObject(forKey: "appid"),
            let rating = aDecoder.decodeObject(forKey: "rating"),
            let rating_id = aDecoder.decodeObject(forKey: "rating_id"),
            let rating_type = aDecoder.decodeObject(forKey: "rating_type"),
            let type_id = aDecoder.decodeObject(forKey: "type_id"),
            let userid = aDecoder.decodeObject(forKey: "userid")
            else{
                return nil
        }
        self.init(appid: appid as! String, rating: rating as! Double,rating_id: rating_id as! String,rating_type: rating_type as! String,type_id: type_id as! Int64,userid: userid as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(appid,     forKey: "appid")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(rating_id, forKey: "rating_id")
        aCoder.encode(rating_type, forKey: "rating_type")
        aCoder.encode(type_id, forKey: "type_id")
        aCoder.encode(userid, forKey: "userid")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        appid <- map["appid"]
        rating <- map["rating"]
        rating_id <- map["rating_id"]
        rating_type <- map["rating_type"]
        type_id <- map["type_id"]
        userid <- map["userid"]
    }
}

class Token: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var token : String? = ""
    var tokenExpirationUtc : Int64? = 0
    var userId : String? = ""
    var userType  : String? = ""
    var username : String? = ""
    
    
    
    required init?(map: Map) {
        
    }
    
    
    init(token: String, tokenExpirationUtc: Int64,userId: String,userType: String,username: String) {
        self.token = token
        self.tokenExpirationUtc = tokenExpirationUtc
        self.userId = userId
        self.userType = userType
        self.username = username
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let token = aDecoder.decodeObject(forKey: "token"),
            let tokenExpirationUtc = aDecoder.decodeObject(forKey: "tokenExpirationUtc"),
            let userId = aDecoder.decodeObject(forKey: "userId"),
            let userType = aDecoder.decodeObject(forKey: "userType"),
            let username = aDecoder.decodeObject(forKey: "username")
            else{
                return nil
        }
        self.init(token: token as! String, tokenExpirationUtc: tokenExpirationUtc as! Int64,userId: userId as! String,userType: userType as! String,username: username as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(token,     forKey: "token")
        aCoder.encode(tokenExpirationUtc, forKey: "tokenExpirationUtc")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(userType, forKey: "userType")
        aCoder.encode(username, forKey: "username")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        token <- map["token"]
        tokenExpirationUtc <- map["tokenExpirationUtc"]
        userId <- map["userId"]
        userType <- map["userType"]
        username <- map["username"]
    }
}

class sync_data: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var notes : [NotesResponse] = []
    var schedules : [Int64] = []
    var sponsor_favorites : [Int64] = []
    var exhibitor_favorites : [Int64] = []
    
    required init?(map: Map) {
        
    }
    
    
    init(notes: [NotesResponse], schedules: [Int64], sponsor_favorites: [Int64], exhibitor_favorites: [Int64]) {
        self.notes = notes
        self.schedules = schedules
        self.sponsor_favorites = sponsor_favorites
        self.exhibitor_favorites = exhibitor_favorites
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let notes = aDecoder.decodeObject(forKey: "notes"),
            let schedules = aDecoder.decodeObject(forKey: "schedules"),
            let sponsor_favorites = aDecoder.decodeObject(forKey: "sponsor_favorites"),
            let exhibitor_favorites = aDecoder.decodeObject(forKey: "exhibitor_favorites")
            else{
                return nil
        }
        self.init(notes: notes as! [NotesResponse], schedules: schedules as! [Int64], sponsor_favorites: sponsor_favorites as! [Int64], exhibitor_favorites: exhibitor_favorites as! [Int64])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(notes,     forKey: "notes")
        aCoder.encode(schedules, forKey: "schedules")
        aCoder.encode(sponsor_favorites,     forKey: "sponsor_favorites")
        aCoder.encode(exhibitor_favorites, forKey: "exhibitor_favorites")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        notes <- map["notes"]
        schedules <- map["schedules"]
        sponsor_favorites <- map["sponsor_favorites"]
        exhibitor_favorites <- map["exhibitor_favorites"]
    }
}

