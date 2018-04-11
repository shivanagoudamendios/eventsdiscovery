//
//  PostLikes.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 12/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class PostLikes: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var postId : String? = ""
    var userId : String? = ""
    var comments : String? = ""
    var name : String? = ""
    var time  : NSNumber? = 0
    var profilepic : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    init(postId: String,userId: String, comments: String,name: String,time: NSNumber,profilepic: String) {
        self.postId = postId
        self.userId = userId
        self.comments = comments
        self.name = name
        self.time = time
        self.profilepic = profilepic
        
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let postId = aDecoder.decodeObject(forKey: "postId"),
            let userId = aDecoder.decodeObject(forKey: "userId"),
            let comments = aDecoder.decodeObject(forKey: "comments"),
            let name = aDecoder.decodeObject(forKey: "name"),
            let time = aDecoder.decodeObject(forKey: "time"),
            let profilepic = aDecoder.decodeObject(forKey: "profilepic")
            else{
                return nil
        }
        self.init(postId: postId as! String,userId: userId as! String, comments: comments as! String,name: name as! String,time: time as! NSNumber,profilepic: profilepic as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(postId,     forKey: "postId")
        aCoder.encode(userId,     forKey: "userId")
        aCoder.encode(comments, forKey: "comments")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(profilepic, forKey: "profilepic")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        postId <- map["postId"]
        userId <- map["userId"]
        comments <- map["comments"]
        name <- map["name"]
        time <- map["time"]
        profilepic <- map["profilepic"]
    }
}
