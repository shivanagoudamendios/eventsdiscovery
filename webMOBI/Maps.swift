//
//  Maps.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class Maps: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(type,     forKey: "type")
        aCoder.encode(checkvalue,     forKey: "checkvalue")
        aCoder.encode(iconCls, forKey: "iconCls")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(venue, forKey: "venue")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lng, forKey: "lng")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(floors, forKey: "floors")
        aCoder.encode(maps, forKey: "maps")
    }

    var type : String? = ""
    var checkvalue : String? = ""
    var iconCls : String? = ""
    var title : String? = ""
    var caption  : String? = ""
    var venue : String? = ""
    var lat : String? = ""
    var lng : String? = ""
    var desc : String? = ""
    var floors : [Floors]? = [Floors]()
    var maps : [MapsInMaps]? = [MapsInMaps]()
    
    
    
    required init?(map: Map) {
        
    }
    
    init(type: String, checkvalue: String,iconCls: String,title: String,caption: String,venue: String,lat: String,lng: String,desc: String,floors: [Floors],maps: [MapsInMaps]) {
        self.type = type
        self.checkvalue = checkvalue
        self.iconCls = iconCls
        self.title = title
        self.caption = caption
        self.venue = venue
        self.lat = lat
        self.lng = lng
        self.desc = desc
        self.floors = floors
        self.maps = maps
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let type = aDecoder.decodeObject(forKey: "type"),
            let checkvalue = aDecoder.decodeObject(forKey: "checkvalue"),
            let iconCls = aDecoder.decodeObject(forKey: "iconCls"),
            let title = aDecoder.decodeObject(forKey: "title"),
            let caption = aDecoder.decodeObject(forKey: "caption"),
            let venue = aDecoder.decodeObject(forKey: "venue"),
            let lat = aDecoder.decodeObject(forKey: "lat"),
            let lng = aDecoder.decodeObject(forKey: "lng"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let floors = aDecoder.decodeObject(forKey: "floors"),
            let maps = aDecoder.decodeObject(forKey: "maps")
            
            else{
                return nil
        }
        self.init(type: type as! String, checkvalue: checkvalue as! String,iconCls: iconCls as! String,title: title as! String,caption: caption as! String,venue: venue as! String,lat: lat as! String,lng: lng as! String,desc: desc as! String,floors: floors as! [Floors] ,maps: maps as! [MapsInMaps])
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(type,     forKey: "type")
//        aCoder.encode(checkvalue,     forKey: "checkvalue")
//        aCoder.encode(iconCls, forKey: "iconCls")
//        aCoder.encode(title, forKey: "title")
//        aCoder.encode(caption, forKey: "caption")
//        aCoder.encode(venue, forKey: "venue")
//        aCoder.encode(lat, forKey: "lat")
//        aCoder.encode(lng, forKey: "lng")
//        aCoder.encode(desc, forKey: "desc")
//        aCoder.encode(floors, forKey: "floors")
//        aCoder.encode(maps, forKey: "maps")
//    }
    
    // Mappable
    func mapping(map: Map) {
        type <- map["type"]
        checkvalue <- map["checkvalue"]
        iconCls <- map["iconCls"]
        title <- map["title"]
        caption <- map["caption"]
        venue <- map["venue"]
        lat <- map["lat"]
        lng <- map["lng"]
        desc <- map["description"]
        floors <- map["floors"]
        maps <- map["maps"]
    }
}
