//
//  SponsorsDataItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class SponsorsDataItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(company,     forKey: "company")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(detail,    forKey: "detail")
        
        aCoder.encode(website,     forKey: "website")
        aCoder.encode(fblink,    forKey: "fblink")
        
        aCoder.encode(twittername,     forKey: "twittername")
        aCoder.encode(linkedinlink, forKey: "linkedinlink")
        aCoder.encode(image,    forKey: "image")
        
        aCoder.encode(sponsor,    forKey: "sponsor")
        aCoder.encode(categories,    forKey: "categories")
        aCoder.encode(sponsor_id,    forKey: "sponsor_id")
    }
    
    var company : String? = ""
    var desc : String? = ""
    var detail : String? = ""
    var website  : String? = ""
    var fblink : String? = ""
    var twittername : String? = ""
    var linkedinlink : String? = ""
    var image  : String? = ""
    var sponsor : String? = ""
    var categories : String? = ""
    var sponsor_id : Int64?
    required init?(map: Map) {
        
    }
    
    init(company: String, desc: String, detail: String, website: String, fblink: String,twittername: String, linkedinlink: String, image: String, sponsor: String,categories : String,sponsor_id : Int64) {
        
        
        self.company = company
        self.desc = desc
        self.detail = detail
        self.website = website
        self.fblink = fblink
        self.twittername = twittername
        self.linkedinlink = linkedinlink
        self.image = image
        self.sponsor = sponsor
        self.categories = categories
        self.sponsor_id = sponsor_id
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let company = aDecoder.decodeObject(forKey: "company"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let detail = aDecoder.decodeObject(forKey: "detail"),
            let website = aDecoder.decodeObject(forKey: "website"),
            let fblink = aDecoder.decodeObject(forKey: "fblink"),
            let twittername = aDecoder.decodeObject(forKey: "twittername"),
            let linkedinlink = aDecoder.decodeObject(forKey: "linkedinlink"),
            let image = aDecoder.decodeObject(forKey: "image"),
            let sponsor = aDecoder.decodeObject(forKey: "sponsor"),
            let categories = aDecoder.decodeObject(forKey: "categories"),
            let sponsor_id = aDecoder.decodeObject(forKey: "sponsor_id")
            else{
                return nil
        }
        self.init(company: company as! String, desc: desc as! String, detail: detail as! String, website: website as! String, fblink: fblink as! String,twittername: twittername as! String, linkedinlink: linkedinlink as! String, image: image as! String, sponsor: sponsor as! String,categories : categories as! String,sponsor_id : sponsor_id as! Int64)
    }
    
    //    func encodeWithCoder(aCoder: NSCoder) {
    //        aCoder.encode(company,     forKey: "company")
    //        aCoder.encode(desc, forKey: "desc")
    //        aCoder.encode(detail,    forKey: "detail")
    //
    //        aCoder.encode(website,     forKey: "website")
    //        aCoder.encode(fblink,    forKey: "fblink")
    //
    //        aCoder.encode(twittername,     forKey: "twittername")
    //        aCoder.encode(linkedinlink, forKey: "linkedinlink")
    //        aCoder.encode(image,    forKey: "image")
    //
    //        aCoder.encode(sponsor,    forKey: "sponsor")
    //        aCoder.encode(notes,    forKey: "notes")
    //    }
    
    
    
    // Mappable
    func mapping(map: Map) {
        company <- map["company"]
        desc <- map["description"]
        detail <- map["detail"]
        website <- map["website"]
        fblink <- map["fblink"]
        twittername <- map["twittername"]
        linkedinlink <- map["linkedinlink"]
        image <- map["image"]
        sponsor <- map["sponsor"]
        categories <- map["categories"]
        sponsor_id <- map["sponsor_id"]
    }
}
