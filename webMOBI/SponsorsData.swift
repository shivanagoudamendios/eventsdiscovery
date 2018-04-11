//
//  SponsorsData.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class SponsorsData: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(checkvalue,     forKey: "checkvalue")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title,    forKey: "title")
        aCoder.encode(caption,     forKey: "caption")
        aCoder.encode(categories,     forKey: "categories")
        aCoder.encode(items, forKey: "items")
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var categories : [Categories] = [Categories]()
    var items : [SponsorsDataItems]? = [SponsorsDataItems]()
    
    
    
    required init?(map: Map) {
        
    }
    
    init(type: String,checkvalue: String, iconCls: String, title: String, caption: String,categories: [Categories],items: [SponsorsDataItems]) {
        self.type = type
        self.checkvalue = checkvalue
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.items = items
        self.categories = categories
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let categories = aDecoder.decodeObject(forKey: "categories"),
            let items = aDecoder.decodeObject(forKey: "items")
            else{
                return nil
        }
        self.init(type: type as! String,checkvalue: checkvalue as! String, iconCls: iconCls as! String, title: title as! String, caption: caption as! String,categories : categories as! [Categories], items: items as! [SponsorsDataItems])
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(type,     forKey: "type")
//        aCoder.encode(checkvalue,     forKey: "checkvalue")
//        aCoder.encode(iconCls, forKey: "iconCls")
//        aCoder.encode(title,    forKey: "title")
//        aCoder.encode(caption,     forKey: "caption")
//        aCoder.encode(items, forKey: "items")
//    }
    
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        checkvalue <- map["checkvalue"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        categories <- map["categories"]
        items <- map["items"]
    }
}
