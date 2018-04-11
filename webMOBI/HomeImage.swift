//
//  HomeImage.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/13/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeImage: NSObject,Mappable {
    var image : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    init(image: String) {
        self.image = image
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let image = aDecoder.decodeObject(forKey: "image")
            else{
                return nil
        }
        self.init(image: image as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(image,  forKey: "image")
    }
    

    // Mappable
    func mapping(map: Map) {
        image <- map["image"]
    }
}
