//
//  BannerItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/13/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class BannerItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var imgUrl : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    init(imgUrl: String) {
        self.imgUrl = imgUrl
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let imgUrl = aDecoder.decodeObject(forKey: "imgUrl")
            else{
                return nil
        }
        self.init(imgUrl: imgUrl as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(imgUrl,  forKey: "imgUrl")
    }

    // Mappable
    func mapping(map: Map) {
        imgUrl <- map["imgUrl"]
    }
}
