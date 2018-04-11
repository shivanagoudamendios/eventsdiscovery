//
//  SingleUserMessaging.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class SingleUserMessaging: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var type : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(type: String, iconCls: String,title: String,caption: String) {
        self.type = type
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption")
            else{
                return nil
        }
        self.init(type: type as! String, iconCls: iconCls as! String,title: title as! String,caption: caption as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
    }
    

    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
    }
}
