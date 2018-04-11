//
//  ExhibitorsDataCategories.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class ExhibitorsDataCategories: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var category : String? = ""
    
    required init?(map: Map) {
        
    }
    init(category: String) {
        self.category = category
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let category = aDecoder.decodeObject(forKey: "category")
            else{
                return nil
        }
        self.init(category: category as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(category,     forKey: "category")
     
    }

    
    // Mappable
    func mapping(map: Map) {
        category <- map["category"]
    }
}
