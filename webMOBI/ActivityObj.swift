//
//  ActivityObj.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 12/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivityObj: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var postId : String? = ""
    var name : String? = ""
    var profilepic : String? = ""
    var status : String? = ""
    var image  : String? = ""
    var url : String? = ""
    var postTime : NSNumber? = 0
    var comments : NSNumber? = 0
    var likes : NSNumber? = 0
    var myLike : Bool? = false
    
    
    required init?(map: Map) {
        
    }
    
    init(postId: String,name: String, profilepic: String,status: String,image: String,url: String,postTime: NSNumber,comments: NSNumber,likes:NSNumber ,myLike:Bool) {
        self.postId = postId
        self.name = name
        self.profilepic = profilepic
        self.status = status
        self.image = image
        self.url = url
        self.postTime = postTime
        self.comments = comments
        self.likes = likes
        self.myLike = myLike
        
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let postId = aDecoder.decodeObject(forKey: "postId"),
            let name = aDecoder.decodeObject(forKey: "name"),
            let profilepic = aDecoder.decodeObject(forKey: "profilepic"),
            let status = aDecoder.decodeObject(forKey: "status"),
            let image = aDecoder.decodeObject(forKey: "image"),
            let url = aDecoder.decodeObject(forKey: "url"),
            let postTime = aDecoder.decodeObject(forKey: "postTime"),
            let comments = aDecoder.decodeObject(forKey: "comments"),
            let likes = aDecoder.decodeObject(forKey: "likes"),
            let myLike = aDecoder.decodeObject(forKey: "myLike")
            else{
                return nil
        }
        self.init(postId: postId as! String,name: name as! String, profilepic: profilepic as! String,status: status as! String,image: image as! String,url: url as! String,postTime: postTime as! NSNumber,comments: comments as! NSNumber,likes: likes as! NSNumber,myLike: myLike as! Bool)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(postId,     forKey: "postId")
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(profilepic, forKey: "profilepic")
        aCoder.encode(status, forKey: "status")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(postTime, forKey: "postTime")
        aCoder.encode(comments, forKey: "comments")
         aCoder.encode(likes, forKey: "likes")
         aCoder.encode(myLike, forKey: "myLike")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        postId <- map["postId"]
        name <- map["name"]
        profilepic <- map["profilepic"]
        status <- map["status"]
        image <- map["image"]
        url <- map["url"]
        postTime <- map["postTime"]
        comments <- map["comments"]
        likes <- map["likes"]
        myLike <- map["myLike"]
    }
}
