//
//  Floors.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class Floors: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(places, forKey: "places")
    }

    var name : String? = ""
    var imageUrl : String? = ""
    var desc : String? = ""
    var places  : [Places]? = [Places]()
    
    required init?(map: Map) {
        
    }
    
    init(name: String, imageUrl: String,desc: String,places: [Places]) {
        self.name = name
        self.imageUrl = imageUrl
        self.desc = desc
        self.places = places
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let imageUrl = aDecoder.decodeObject(forKey: "imageUrl"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let places = aDecoder.decodeObject(forKey: "places")
            
            else{
                return nil
        }
        self.init(name: name as! String, imageUrl: imageUrl as! String,desc: desc as! String,places: places as! [Places])
    }
    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(name,     forKey: "name")
//        aCoder.encode(imageUrl, forKey: "imageUrl")
//        aCoder.encode(desc, forKey: "desc")
//        aCoder.encode(places, forKey: "places")
//    }

    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        desc <- map["description"]
        places <- map["places"]
    }
}
