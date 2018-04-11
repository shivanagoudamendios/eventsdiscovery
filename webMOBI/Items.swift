//
//  Items.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class Items: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var name : String? = ""
    var link : String? = ""
    var image_url : String? = ""
    var date  : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(name: String, link: String,image_url: String,date: String) {
        self.name = name
        self.link = link
        self.image_url = image_url
        self.date = date
   
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let link = aDecoder.decodeObject(forKey: "link"),
            let image_url = aDecoder.decodeObject(forKey: "image_url"),
            let date = aDecoder.decodeObject(forKey: "date")
            else{
                return nil
        }
        self.init(name: name as! String, link: link as! String,image_url: image_url as! String,date: date as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(link, forKey: "link")
        aCoder.encode(image_url, forKey: "image_url")
        aCoder.encode(date, forKey: "date")
    }

    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        link <- map["link"]
        image_url <- map["image_url"]
        date <- map["date"]
    }
}
