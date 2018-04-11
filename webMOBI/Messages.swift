//
//  Messages.swift
//  VimiCommunication
//
//  Created by Gnani Naidu on 4/5/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper
class Messages: NSObject,Mappable,NSCoding {
    var id : String? = ""
    var From_UserID : String? = ""
    var msg : String? = ""
    var From_UserName : String? = ""
    var TimeinMilli : String? = ""
    var msg_datatype : String? = ""
    required init?(map: Map) {
        
    }
    
    init(id: String, From_UserID: String,msg: String,From_UserName: String, TimeinMilli: String, msg_datatype: String) {
        self.id = id
        self.From_UserID = From_UserID
        self.msg = msg
        self.From_UserName = From_UserName
        self.TimeinMilli = TimeinMilli
        self.msg_datatype = msg_datatype
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id"),
            let From_UserID = aDecoder.decodeObject(forKey: "From_UserID"),
            let msg = aDecoder.decodeObject(forKey: "msg"),
            let From_UserName = aDecoder.decodeObject(forKey: "From_UserName"),
            let TimeinMilli = aDecoder.decodeObject(forKey: "TimeinMilli"),
            let msg_datatype = aDecoder.decodeObject(forKey: "msg_datatype")
            else{
                return nil
        }
        self.init(id: id as! String, From_UserID: From_UserID as! String,msg: msg as! String,From_UserName: From_UserName as! String,TimeinMilli: TimeinMilli as! String, msg_datatype: msg_datatype as! String)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,     forKey: "id")
        aCoder.encode(From_UserID, forKey: "From_UserID")
        aCoder.encode(msg, forKey: "msg")
        aCoder.encode(From_UserName, forKey: "From_UserName")
        aCoder.encode(TimeinMilli, forKey: "TimeinMilli")
        aCoder.encode(msg_datatype, forKey: "msg_datatype")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        id <- map["id"]
        From_UserID <- map["From_UserID"]
        msg <- map["msg"]
        From_UserName <- map["From_UserName"]
        TimeinMilli <- map["TimeinMilli"]
        msg_datatype <- map["msg_datatype"]
    }
}

