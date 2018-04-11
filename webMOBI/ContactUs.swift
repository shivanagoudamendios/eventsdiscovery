//
//  ContactUs.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class ContactUs: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(checkvalue,     forKey: "checkvalue")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(toEmail, forKey: "toEmail")
        aCoder.encode(fromEmail, forKey: "fromEmail")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(phone, forKey: "phone")
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var toEmail : String? = ""
    var fromEmail : String? = ""
    var url : String? = ""
    var phone : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    init(type: String,checkvalue: String, iconCls: String,title: String,caption: String,toEmail: String,fromEmail: String,url: String, phone : String) {
        self.type = type
        self.checkvalue = checkvalue
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.toEmail = toEmail
        self.fromEmail = fromEmail
        self.url = url
        self.phone = phone
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let toEmail = aDecoder.decodeObject(forKey: "toEmail"),
            let fromEmail = aDecoder.decodeObject(forKey: "fromEmail"),
            let url = aDecoder.decodeObject(forKey: "url"),
            let phone = aDecoder.decodeObject(forKey: "phone")
            else{
                return nil
        }
        self.init(type: type as! String,checkvalue: checkvalue as! String, iconCls: iconCls as! String,title: title as! String,caption: caption as! String,toEmail: toEmail as! String,fromEmail: fromEmail as! String,url: url as! String, phone : phone as! String)
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(type,     forKey: "type")
//        aCoder.encode(checkvalue,     forKey: "checkvalue")
//        aCoder.encode(iconCls, forKey: "iconCls")
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(caption, forKey: "caption")
//        aCoder.encode(toEmail, forKey: "toEmail")
//        aCoder.encode(fromEmail, forKey: "fromEmail")
//        aCoder.encode(url, forKey: "url")
//        aCoder.encode(mobile, forKey: "mobile")
//    }
    
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        checkvalue <- map["checkvalue"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        toEmail <- map["toEmail"]
        fromEmail <- map["fromEmail"]
        url <- map["url"]
        phone <- map["phone"]
    }
}
