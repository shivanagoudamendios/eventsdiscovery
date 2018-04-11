//
//  ExhibitorsDataProducts.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class ExhibitorsDataProducts: NSObject,Mappable {
    var product : String? = ""
    var desc : String? = ""
    var about : String? = ""
    var logoLmage : String? = ""

    
    required init?(map: Map) {
        
    }
    
    init(product: String, desc: String, about: String, logoLmage: String) {
        
        self.product = product
        self.desc = desc
        self.about = about
        self.logoLmage = logoLmage
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let product = aDecoder.decodeObject(forKey: "product"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let about = aDecoder.decodeObject(forKey: "about"),
            let logoLmage = aDecoder.decodeObject(forKey: "logoLmage")
            else{
                return nil
        }
        self.init(product: product as! String, desc: desc as! String, about: about as! String, logoLmage: logoLmage as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(product,     forKey: "product")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(about,    forKey: "about")
        aCoder.encode(logoLmage,     forKey: "logoLmage")
     
    }

    
    // Mappable
    func mapping(map: Map) {
        product <- map["product"]
        desc <- map["description"]
        about <- map["about"]
        logoLmage <- map["logoLmage"]
    }
}
