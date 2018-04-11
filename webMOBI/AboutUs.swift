//
//  AboutUs.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Ankitha. All rights reserved.
//

import Foundation
import ObjectMapper

class AboutUs: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var content : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(type: String, iconCls: String,title: String,caption: String,content: String,checkvalue: String) {
        self.type = type
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.content = content
        self.checkvalue = checkvalue
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let content = aDecoder.decodeObject(forKey: "content"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue")
            else{
                return nil
        }
        self.init(type: type as! String, iconCls: iconCls as! String,title: title as! String,caption: caption as! String,content: content as! String,checkvalue: checkvalue as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(checkvalue, forKey: "checkvalue")
    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        content <- map["content"]
        checkvalue <- map["checkvalue"]
    }
}
