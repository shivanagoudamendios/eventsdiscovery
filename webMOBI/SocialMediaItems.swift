//
//  SocialMediaItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/25/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialMediaItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var type : String? = ""
    var iconCls : String? = ""
    var name : String? = ""
    var url  : String? = ""
  
    
    required init?(map: Map) {
        
    }
    
    init(type: String, iconCls: String,name: String,url: String) {
        self.type = type
        self.iconCls = iconCls
        self.name = name
        self.url = url
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let name = aDecoder.decodeObject(forKey: "name"),
            let url = aDecoder.decodeObject(forKey: "url")
            else{
                return nil
        }
        self.init(type: type as! String, iconCls: iconCls as! String,name: name as! String,url: url as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(url, forKey: "url")
    }

    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        iconCls <- map["iconCls"]
        name <- map["name"]
        url <- map["url"]
    }
}
