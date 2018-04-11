//
//  ChatHistory.swift
//  Pharmacy
//
//  Created by Gnani Naidu on 2/9/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper
class ChatHistory: NSObject,Mappable,NSCoding {
    var id : String? = ""
    var sender_id : String? = ""
    var sender_name : String? = ""
    var message_body : String? = ""
    var create_date : String? = ""
    var msg_datatype : String? = ""
    required init?(map: Map) {
        
    }
    
    init(id: String,sender_id: String, sender_name: String,message_body: String,create_date: String,msg_datatype: String) {
        self.id = id
        self.sender_id = sender_id
        self.sender_name = sender_name
        self.message_body = message_body
        self.create_date = create_date
        self.msg_datatype = msg_datatype
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id"),
            let sender_id = aDecoder.decodeObject(forKey: "sender_id"),
            let sender_name = aDecoder.decodeObject(forKey: "sender_name"),
            let message_body = aDecoder.decodeObject(forKey: "message_body"),
            let create_date = aDecoder.decodeObject(forKey: "create_date"),
            let msg_datatype = aDecoder.decodeObject(forKey: "msg_datatype")
            else{
                return nil
        }
        self.init(id: id as! String,sender_id: sender_id as! String, sender_name: sender_name as! String,message_body: message_body as! String,create_date: create_date as! String,msg_datatype: msg_datatype as! String)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,     forKey: "id")
        aCoder.encode(sender_id,     forKey: "sender_id")
        aCoder.encode(sender_name, forKey: "sender_name")
        aCoder.encode(message_body, forKey: "message_body")
        aCoder.encode(create_date, forKey: "create_date")
        aCoder.encode(msg_datatype, forKey: "msg_datatype")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        sender_id <- map["sender_id"]
        sender_name <- map["sender_name"]
        message_body <- map["message_body"]
        create_date <- map["create_date"]
        msg_datatype <- map["msg_datatype"]
    }
}
