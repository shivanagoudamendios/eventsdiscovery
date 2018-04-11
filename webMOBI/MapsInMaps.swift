//
//  MapsInMaps.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class MapsInMaps: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var name : String? = ""
    var imageUrl : String? = ""
    var desc : String? = ""

    
    required init?(map: Map) {
        
    }
    
    
    init(name: String, imageUrl: String,desc: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.desc = desc
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let imageUrl = aDecoder.decodeObject(forKey: "imageUrl"),
            let desc = aDecoder.decodeObject(forKey: "desc")
            
            else{
                return nil
        }
        self.init(name: name as! String, imageUrl: imageUrl as! String,desc: desc as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(desc, forKey: "desc")
    }
    

    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        desc <- map["description"]
    }
}
