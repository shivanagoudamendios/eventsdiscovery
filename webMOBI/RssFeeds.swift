//
//  RssFeeds.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/20/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class RssFeeds: NSObject,Mappable,NSCoding {
    
    public func encode(with aCoder: NSCoder) {
        
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var url  : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    init(type: String,checkvalue: String, iconCls: String,title: String,caption: String,url: String) {
        self.type = type
        self.checkvalue = checkvalue
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.url = url
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let url = aDecoder.decodeObject(forKey: "url")
            else{
                return nil
        }
        self.init(type: type as! String,checkvalue: checkvalue as! String, iconCls: iconCls as! String,title: title as! String,caption: caption as! String,url: url as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(checkvalue,     forKey: "checkvalue")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(url, forKey: "url")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        checkvalue <- map["checkvalue"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        url <- map["url"]
    }
}
