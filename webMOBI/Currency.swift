//
//  Currency.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/20/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import Foundation
import ObjectMapper

class Currency: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var currencyName : String? = ""
    var id : String? = ""
    
    required init?(map: Map) {
        
    }
    
    init(currencyName: String, id: String) {
        self.currencyName = currencyName
        self.id = id
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let currencyName = aDecoder.decodeObject(forKey: "currencyName"),
            let id = aDecoder.decodeObject(forKey: "id")
            else{
                return nil
        }
        self.init(currencyName: currencyName as! String, id: id as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(currencyName,     forKey: "currencyName")
        aCoder.encode(id, forKey: "id")
    }

    
    // Mappable
    func mapping(map: Map) {
        currencyName <- map["currencyName"]
        id <- map["id"]
    }
}
