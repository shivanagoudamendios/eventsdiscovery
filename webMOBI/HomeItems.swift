//
//  HomeItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/13/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var imagenumber : Int? = 0
    var value : String? = ""
    var imageUrl : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    init(imagenumber: Int,value: String,imageUrl:String) {
        self.imagenumber = imagenumber
        self.value = value
        self.imageUrl = imageUrl
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let imagenumber = aDecoder.decodeObject(forKey: "imagenumber"),
            let value = aDecoder.decodeObject(forKey: "value"),
            let imageUrl = aDecoder.decodeObject(forKey: "imageUrl")
            else{
                return nil
        }
        self.init(imagenumber: imagenumber as! Int,value: value as! String,imageUrl: imageUrl as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(imagenumber,  forKey: "imagenumber")
        aCoder.encode(value,  forKey: "value")
        aCoder.encode(imageUrl,  forKey: "imageUrl")
    }

    
    // Mappable
    func mapping(map: Map) {
        imagenumber <- map["imagenumber"]
        value <- map["value"]
        imageUrl <- map["imageUrl"]
    }
}
