//
//  Home.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/13/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class Home: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var type : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var banner : [BannerItems]? = [BannerItems]()
    var items : [HomeItems]? = [HomeItems]()
    var image : [HomeImage]? = [HomeImage]()
    
    
    required init?(map: Map) {
        
    }
    
    
    init(type: String, iconCls: String,title: String,caption: String,banner: [BannerItems],items: [HomeItems],image: [HomeImage]) {
        self.type = type
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.banner = banner
        self.items = items
        self.image = image
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let banner = aDecoder.decodeObject(forKey: "banner"),
            let items = aDecoder.decodeObject(forKey: "items"),
            let image = aDecoder.decodeObject(forKey: "image")
            else{
                return nil
        }
        self.init(type: type as! String, iconCls: iconCls as! String,title: title as! String,caption: caption as! String,banner: banner as! [BannerItems],items: items as! [HomeItems],image: image as! [HomeImage])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(banner, forKey: "banner")
        aCoder.encode(items, forKey: "items")
        aCoder.encode(image, forKey: "image")
    }
    

    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        banner <- map["banner"]
        items <- map["items"]
        image <- map["image"]
    }
}
