//
//  Places.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/18/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class Places: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var name : String? = ""
    var left : String? = ""
    var top : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(name: String, left: String,top: String) {
        self.name = name
        self.left = left
        self.top = top
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let left = aDecoder.decodeObject(forKey: "left"),
            let top = aDecoder.decodeObject(forKey: "top")
            
            else{
                return nil
        }
        self.init(name: name as! String, left: left as! String,top: top as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(left, forKey: "left")
        aCoder.encode(top, forKey: "top")
    }

    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        left <- map["left"]
        top <- map["top"]
    }
}
