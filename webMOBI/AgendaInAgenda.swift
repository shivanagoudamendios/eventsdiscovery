//
//  AgendaInAgenda.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class AgendaInAgenda: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }

    var name : Double? = 0
    var detail : [AgendaDetails]? = [AgendaDetails]()
    
    required init?(map: Map) {
        
    }
    
    init(name: Double, detail: [AgendaDetails]) {
        self.name = name
        self.detail = detail
       
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name"),
            let detail = aDecoder.decodeObject(forKey: "detail")
            else{
                return nil
        }
        self.init(name: name as! Double, detail: detail as! [AgendaDetails])
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(name,     forKey: "name")
        aCoder.encode(detail, forKey: "detail")
    }

    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        detail <- map["detail"]
    }
}
