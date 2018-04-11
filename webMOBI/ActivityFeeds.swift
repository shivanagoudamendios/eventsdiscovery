//
//  ActivityFeeds.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/3/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class ActivityFeeds: NSObject,Mappable,NSCoding {
    func encode(with aCoder: NSCoder) {
        
    }


    var post_id : UInt64? = 0
    var userid : String? = ""
    var username : String? = ""
    var profile_pic : String? = ""
    var title  : String? = ""
    var post_content : String? = ""
    var likes  : Int? = 0
    var comments : Int? = 0
    var create_time : String? = ""
    var attachments : [FeedsAttachments] = [FeedsAttachments]()
    var like_users : [FeedsLikeUsers] = [FeedsLikeUsers]()
    var comment_users  : [FeedsCommentUsers] = [FeedsCommentUsers]()
    var like_status : Int = 0
    
    required init?(map: Map) {
        
    }
    
    init(post_id: UInt64,userid: String, username: String, profile_pic: String, title: String,post_content: String, likes: Int,comments: Int, create_time: String, attachments: [FeedsAttachments], like_users: [FeedsLikeUsers],comment_users: [FeedsCommentUsers], like_status: Int) {
        self.post_id = post_id
        self.userid = userid
        self.username = username
        self.profile_pic = profile_pic
        self.title = title
        self.post_content = post_content
        self.likes = likes
        self.comments = comments
        self.create_time = create_time
        self.attachments = attachments
        self.like_users = like_users
        self.comment_users = comment_users
        self.like_status = like_status
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let post_id = aDecoder.decodeObject(forKey: "post_id"),
            let userid = aDecoder.decodeObject(forKey: "userid"),
            let username = aDecoder.decodeObject(forKey: "username"),
            let profile_pic = aDecoder.decodeObject(forKey: "profile_pic"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let post_content = aDecoder.decodeObject(forKey: "post_content"),
            let likes = aDecoder.decodeObject(forKey: "likes"),
            let comments = aDecoder.decodeObject(forKey: "comments"),
            let create_time = aDecoder.decodeObject(forKey: "create_time"),
            let attachments = aDecoder.decodeObject(forKey: "attachments"),
            let like_users = aDecoder.decodeObject(forKey: "like_users"),
            let comment_users = aDecoder.decodeObject(forKey: "comment_users"),
            let like_status = aDecoder.decodeObject(forKey: "like_status")
            else{
                return nil
        }
        self.init(post_id: post_id as! UInt64, userid: userid as! String, username: username as! String, profile_pic: profile_pic as! String, title: title as! String,post_content: post_content as! String, likes: likes as! Int,comments: comments as! Int, create_time: create_time as! String, attachments: attachments as! [FeedsAttachments], like_users: like_users as! [FeedsLikeUsers],comment_users: comment_users as! [FeedsCommentUsers], like_status: like_status as! Int)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(post_id,     forKey: "post_id")
        aCoder.encode(userid,     forKey: "userid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(profile_pic,    forKey: "profile_pic")
        aCoder.encode(title,     forKey: "title")
        aCoder.encode(post_content, forKey: "post_content")
        aCoder.encode(likes, forKey: "likes")
        aCoder.encode(comments,     forKey: "comments")
        aCoder.encode(create_time,     forKey: "create_time")
        aCoder.encode(attachments, forKey: "attachments")
        aCoder.encode(like_users,    forKey: "like_users")
        aCoder.encode(comment_users,     forKey: "comment_users")
        aCoder.encode(like_status, forKey: "like_status")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        post_id <- map["post_id"]
        userid <- map["userid"]
        username <- map["username"]
        profile_pic <- map["profile_pic"]
        title <- map["title"]
        post_content <- map["post_content"]
        likes <- map["likes"]
        comments <- map["comments"]
        create_time <- map["create_time"]
        attachments <- map["attachments"]
        like_users <- map["like_users"]
        comment_users <- map["comment_users"]
        like_status <- map["like_status"]
    }
}

class FeedsLikeUsers: NSObject,Mappable,NSCoding {
    func encode(with aCoder: NSCoder) {
        
    }

    var userid : String? = ""
    var username : String? = ""
    var profile_pic : String? = ""
    var like_time : Double? = 0
    
    required init?(map: Map) {
        
    }
    
    init(userid: String,username: String, profile_pic: String, like_time: Double) {
        self.userid = userid
        self.username = username
        self.profile_pic = profile_pic
        self.like_time = like_time
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let userid = aDecoder.decodeObject(forKey: "userid"),
            let username = aDecoder.decodeObject(forKey: "username"),
            let profile_pic = aDecoder.decodeObject(forKey: "profile_pic"),
            let like_time = aDecoder.decodeObject(forKey: "like_time")
            else{
                return nil
        }
        self.init(userid: userid as! String, username: username as! String, profile_pic: profile_pic as! String, like_time: like_time as! Double)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(userid,     forKey: "userid")
        aCoder.encode(username,     forKey: "username")
        aCoder.encode(profile_pic, forKey: "profile_pic")
        aCoder.encode(like_time,    forKey: "like_time")
    }
    
    // Mappable
    func mapping(map: Map) {
        userid <- map["userid"]
        username <- map["username"]
        profile_pic <- map["profile_pic"]
        like_time <- map["like_time"]
    }
}

class FeedsCommentUsers: NSObject,Mappable,NSCoding {
    func encode(with aCoder: NSCoder) {
        
    }

    var userid : String? = ""
    var username : String? = ""
    var profile_pic : String? = ""
    var comment_time : Double? = 0
    
    required init?(map: Map) {
        
    }
    
    init(userid: String,username: String, profile_pic: String, comment_time: Double) {
        self.userid = userid
        self.username = username
        self.profile_pic = profile_pic
        self.comment_time = comment_time
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let userid = aDecoder.decodeObject(forKey: "userid"),
            let username = aDecoder.decodeObject(forKey: "username"),
            let profile_pic = aDecoder.decodeObject(forKey: "profile_pic"),
            let comment_time = aDecoder.decodeObject(forKey: "comment_time")
            else{
                return nil
        }
        self.init(userid: userid as! String, username: username as! String, profile_pic: profile_pic as! String, comment_time: comment_time as! Double)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(userid,     forKey: "userid")
        aCoder.encode(username,     forKey: "username")
        aCoder.encode(profile_pic, forKey: "profile_pic")
        aCoder.encode(comment_time,    forKey: "comment_time")
    }
    
    // Mappable
    func mapping(map: Map) {
        userid <- map["userid"]
        username <- map["username"]
        profile_pic <- map["profile_pic"]
        comment_time <- map["comment_time"]
    }
}

class FeedsAttachments: NSObject,Mappable,NSCoding {
    func encode(with aCoder: NSCoder) {
        
    }

    var resource_id : Double? = 0
    var res_name : String? = ""
    var res_url : String? = ""
    var res_description : String? = ""
    var res_type : String? = ""
    var res_width : String? = ""
    var res_height : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(resource_id: Double,res_name: String, res_url: String, res_description: String,res_type: String, res_width: String, res_height: String) {
        self.resource_id = resource_id
        self.res_name = res_name
        self.res_url = res_url
        self.res_description = res_description
        self.res_type = res_type
        self.res_width = res_width
        self.res_height = res_height
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let resource_id = aDecoder.decodeObject(forKey: "resource_id"),
            let res_name = aDecoder.decodeObject(forKey: "res_name"),
            let res_url = aDecoder.decodeObject(forKey: "res_url"),
            let res_description = aDecoder.decodeObject(forKey: "res_description"),
            let res_type = aDecoder.decodeObject(forKey: "res_type"),
            let res_width = aDecoder.decodeObject(forKey: "res_width"),
            let res_height = aDecoder.decodeObject(forKey: "res_height")
            else{
                return nil
        }
        self.init(resource_id: resource_id as! Double, res_name: res_name as! String, res_url: res_url as! String, res_description: res_description as! String, res_type: res_type as! String, res_width: res_width as! String, res_height: res_height as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(resource_id,     forKey: "resource_id")
        aCoder.encode(res_name,     forKey: "res_name")
        aCoder.encode(res_url, forKey: "res_url")
        aCoder.encode(res_description,    forKey: "res_description")
        aCoder.encode(res_type,     forKey: "res_type")
        aCoder.encode(res_width, forKey: "res_width")
        aCoder.encode(res_height,    forKey: "res_height")
    }
    
    // Mappable
    func mapping(map: Map) {
        resource_id <- map["resource_id"]
        res_name <- map["res_name"]
        res_url <- map["res_url"]
        res_description <- map["res_description"]
        res_type <- map["res_type"]
        res_width <- map["res_width"]
        res_height <- map["res_height"]
    }
}
