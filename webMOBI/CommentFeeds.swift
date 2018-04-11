//
//  CommentFeeds.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/8/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class CommentFeeds: NSObject,Mappable,NSCoding {
    func encode(with aCoder: NSCoder) {
        
    }
    
    
    var id : UInt64? = 0
    var appid : String? = ""
    var post_id : UInt64? = 0
    var userid : String? = ""
    var comment  : String? = ""
    var comment_time : Double? = 0
    var username  : String? = ""
    var profile_pic : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(id: UInt64,appid: String, post_id: UInt64, userid: String, comment: String,comment_time: Double, username: String, profile_pic: String) {
        self.id = id
        self.appid = appid
        self.post_id = post_id
        self.userid = userid
        self.comment = comment
        self.comment_time = comment_time
        self.username = username
        self.profile_pic = profile_pic
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id"),
            let appid = aDecoder.decodeObject(forKey: "appid"),
            let post_id = aDecoder.decodeObject(forKey: "post_id"),
            let userid = aDecoder.decodeObject(forKey: "userid"),
            let comment = aDecoder.decodeObject(forKey: "comment"),
            let comment_time = aDecoder.decodeObject(forKey: "comment_time"),
            let username = aDecoder.decodeObject(forKey: "username"),
            let profile_pic = aDecoder.decodeObject(forKey: "profile_pic")
            else{
                return nil
        }
        self.init(id: id as! UInt64, appid: appid as! String, post_id: post_id as! UInt64, userid: userid as! String, comment: comment as! String,comment_time: comment_time as! Double, username: username as! String, profile_pic: profile_pic as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(id,     forKey: "id")
        aCoder.encode(appid,     forKey: "appid")
        aCoder.encode(post_id, forKey: "post_id")
        aCoder.encode(userid,    forKey: "userid")
        aCoder.encode(comment,     forKey: "comment")
        aCoder.encode(comment_time, forKey: "comment_time")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(profile_pic,     forKey: "profile_pic")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        appid <- map["appid"]
        post_id <- map["post_id"]
        userid <- map["userid"]
        comment <- map["comment"]
        comment_time <- map["comment_time"]
        username <- map["username"]
        profile_pic <- map["profile_pic"]
    }
}
