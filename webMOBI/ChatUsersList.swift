//
//  ChatUsersList.swift
//  Pharmacy
//
//  Created by Gnani Naidu on 2/9/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper


class ChatUsersList: NSObject,Mappable,NSCoding {
    var sendmsg : [Sendmsgs] = [Sendmsgs]()
    var receivemsg : [Receivemsgs] = [Receivemsgs]()
    var groupmsg : [groupmsgs] = [groupmsgs]()
    
    required init?(map: Map) {
        
    }
    
    init(sendmsg: [Sendmsgs], receivemsg: [Receivemsgs],groupmsg:[groupmsgs]) {
        self.sendmsg = sendmsg
        self.receivemsg = receivemsg
        self.groupmsg = groupmsg
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let sendmsg = aDecoder.decodeObject(forKey: "sendmsg"),
            let receivemsg = aDecoder.decodeObject(forKey: "receivemsg"),
            let groupmsg = aDecoder.decodeObject(forKey: "groupmsg")
            else{
                return nil
        }
        self.init(sendmsg: sendmsg as! [Sendmsgs], receivemsg: receivemsg as! [Receivemsgs],groupmsg: groupmsg as! [groupmsgs])
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sendmsg,     forKey: "sendmsg")
        aCoder.encode(receivemsg, forKey: "receivemsg")
        aCoder.encode(groupmsg, forKey: "groupmsg")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        sendmsg <- map["sendmsg"]
        receivemsg <- map["receivemsg"]
        groupmsg <- map["groupmsg"]
    }
}

class Sendmsgs: NSObject,Mappable,NSCoding {
    var sender_id : String? = ""
    var sender_name : String? = ""
    var message_body : String? = ""
    var msg_datatype : String? = ""
    var create_date : String? = ""
    var profile_image_url : String? = ""
    var unread_count : Int? = 0
    required init?(map: Map) {
        
    }
    
    init(sender_id: String, sender_name: String,message_body: String,msg_datatype: String, create_date: String, profile_image_url: String, unread_count: Int) {
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.message_body = message_body
        self.msg_datatype = msg_datatype
        self.create_date = create_date
        self.profile_image_url = profile_image_url
        self.unread_count = unread_count
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let sender_id = aDecoder.decodeObject(forKey: "sender_id"),
            let sender_name = aDecoder.decodeObject(forKey: "sender_name"),
            let message_body = aDecoder.decodeObject(forKey: "message_body"),
            let msg_datatype = aDecoder.decodeObject(forKey: "msg_datatype"),
            let create_date = aDecoder.decodeObject(forKey: "create_date"),
            let profile_image_url = aDecoder.decodeObject(forKey: "create_date"),
            let unread_count = aDecoder.decodeObject(forKey: "unread_count")
            else{
                return nil
        }
        self.init(sender_id: sender_id as! String, sender_name: sender_name as! String,message_body: message_body as! String,msg_datatype: msg_datatype as! String,create_date: create_date as! String, profile_image_url: profile_image_url as! String, unread_count: unread_count as! Int)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sender_id,     forKey: "sender_id")
        aCoder.encode(sender_name, forKey: "sender_name")
        aCoder.encode(message_body, forKey: "message_body")
        aCoder.encode(msg_datatype, forKey: "msg_datatype")
        aCoder.encode(create_date, forKey: "create_date")
        aCoder.encode(profile_image_url, forKey: "profile_image_url")
        aCoder.encode(unread_count, forKey: "unread_count")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        sender_id <- map["id"]
        sender_name <- map["name"]
        message_body <- map["message"]
        msg_datatype <- map["msg_datatype"]
        create_date <- map["create_date"]
        profile_image_url <- map["profile_pic"]
        unread_count <- map["unread_count"]
    }
}

class Receivemsgs: NSObject,Mappable,NSCoding {
    var sender_id : String? = ""
    var sender_name : String? = ""
    var message_body : String? = ""
    var msg_datatype : String? = ""
    var create_date : String? = ""
    var profile_image_url : String? = ""
    var unread_count : Int? = 0
    required init?(map: Map) {
        
    }
    
    init(sender_id: String, sender_name: String,message_body: String,msg_datatype: String,create_date: String, profile_image_url: String, unread_count: Int) {
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.message_body = message_body
        self.msg_datatype = msg_datatype
        self.create_date = create_date
        self.profile_image_url = profile_image_url
        self.unread_count = unread_count
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let sender_id = aDecoder.decodeObject(forKey: "sender_id"),
            let sender_name = aDecoder.decodeObject(forKey: "sender_name"),
            let message_body = aDecoder.decodeObject(forKey: "message_body"),
            let msg_datatype = aDecoder.decodeObject(forKey: "msg_datatype"),
            let create_date = aDecoder.decodeObject(forKey: "create_date"),
            let profile_image_url = aDecoder.decodeObject(forKey: "create_date"),
            let unread_count = aDecoder.decodeObject(forKey: "unread_count")
            else{
                return nil
        }
        self.init(sender_id: sender_id as! String, sender_name: sender_name as! String,message_body: message_body as! String,msg_datatype: msg_datatype as! String,create_date: create_date as! String, profile_image_url: profile_image_url as! String,unread_count: unread_count as! Int)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sender_id,     forKey: "sender_id")
        aCoder.encode(sender_name, forKey: "sender_name")
        aCoder.encode(message_body, forKey: "message_body")
        aCoder.encode(msg_datatype, forKey: "msg_datatype")
        aCoder.encode(create_date, forKey: "create_date")
        aCoder.encode(profile_image_url, forKey: "profile_image_url")
        aCoder.encode(unread_count, forKey: "unread_count")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        sender_id <- map["id"]
        sender_name <- map["name"]
        message_body <- map["message"]
        msg_datatype <- map["msg_datatype"]
        create_date <- map["create_date"]
        profile_image_url <- map["profile_pic"]
        unread_count <- map["unread_count"]
    }
}

class groupmsgs: NSObject,Mappable,NSCoding {
    var sender_id : String? = ""
    var sender_name : String? = ""
    var message_body : String? = ""
    var create_date : String? = ""
    var profile_image_url : String? = ""
    required init?(map: Map) {
        
    }
    
    init(sender_id: String, sender_name: String,message_body: String,create_date: String, profile_image_url: String) {
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.message_body = message_body
        self.create_date = create_date
        self.profile_image_url = profile_image_url
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let sender_id = aDecoder.decodeObject(forKey: "sender_id"),
            let sender_name = aDecoder.decodeObject(forKey: "sender_name"),
            let message_body = aDecoder.decodeObject(forKey: "message_body"),
            let create_date = aDecoder.decodeObject(forKey: "create_date"),
            let profile_image_url = aDecoder.decodeObject(forKey: "create_date")
            else{
                return nil
        }
        self.init(sender_id: sender_id as! String, sender_name: sender_name as! String,message_body: message_body as! String,create_date: create_date as! String, profile_image_url: profile_image_url as! String)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sender_id,     forKey: "sender_id")
        aCoder.encode(sender_name, forKey: "sender_name")
        aCoder.encode(message_body, forKey: "message_body")
        aCoder.encode(create_date, forKey: "create_date")
        aCoder.encode(profile_image_url, forKey: "profile_image_url")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        sender_id <- map["group_id"]
        sender_name <- map["name"]
        message_body <- map["message_body"]
        create_date <- map["create_date"]
        profile_image_url <- map["profile_image_url"]
    }
}


