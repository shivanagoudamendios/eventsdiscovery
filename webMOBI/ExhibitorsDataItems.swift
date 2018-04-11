//
//  ExhibitorsDataItems.swift
//  WebmobiEvents
//
//  Created by webmobi on 6/1/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class ExhibitorsDataItems: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(company,     forKey: "company")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(detail,    forKey: "detail")
        
        aCoder.encode(website,     forKey: "website")
        aCoder.encode(sponsortype, forKey: "sponsortype")
        aCoder.encode(fblink,    forKey: "fblink")
        
        aCoder.encode(twittername,     forKey: "twittername")
        aCoder.encode(linkedinlink, forKey: "linkedinlink")
        aCoder.encode(image,    forKey: "image")
        
        
        aCoder.encode(docLink,    forKey: "docLink")
        aCoder.encode(categories,     forKey: "categories")
        
        aCoder.encode(exhibitor_id,    forKey: "exhibitor_id")
    }
    
    var company : String? = ""
    var desc: String? = ""
    var detail : String? = ""
    var website  : String? = ""
    var sponsortype : String? = ""
    var fblink : String? = ""
    var twittername  : String? = ""
    var linkedinlink : String? = ""
    var image  : String? = ""
    var docLink : String? = ""
    var categories  : String? = ""
    var exhibitor_id  : Int64?
    
    required init?(map: Map) {
        
    }
    init(company: String, desc: String, detail: String, website: String,sponsortype: String, fblink: String,twittername: String, linkedinlink: String, image: String, docLink: String, categories: String, exhibitor_id: Int64) {
        
        
        self.company = company
        self.desc = desc
        self.detail = detail
        self.website = website
        self.sponsortype = sponsortype
        self.fblink = fblink
        self.twittername = twittername
        self.linkedinlink = linkedinlink
        self.image = image
        self.docLink = docLink
        self.categories = categories
        self.exhibitor_id = exhibitor_id
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let company = aDecoder.decodeObject(forKey: "company"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let detail = aDecoder.decodeObject(forKey: "detail"),
            let website = aDecoder.decodeObject(forKey: "website"),
            let sponsortype = aDecoder.decodeObject(forKey: "sponsortype"),
            let fblink = aDecoder.decodeObject(forKey: "fblink"),
            let twittername = aDecoder.decodeObject(forKey: "twittername"),
            let linkedinlink = aDecoder.decodeObject(forKey: "linkedinlink"),
            let image = aDecoder.decodeObject(forKey: "image"),
            let docLink = aDecoder.decodeObject(forKey: "docLink"),
            let categories  = aDecoder.decodeObject(forKey: "categories"),
            let exhibitor_id = aDecoder.decodeObject(forKey: "exhibitor_id")
            else{
                return nil
        }
        self.init(company: company as! String, desc: desc as! String, detail: detail as! String, website: website as! String,sponsortype: sponsortype as! String, fblink: fblink as! String,twittername: twittername as! String, linkedinlink: linkedinlink as! String, image: image as! String, docLink: docLink as! String, categories: categories as! String, exhibitor_id: exhibitor_id as! Int64)
    }
    
    //    func encodeWithCoder(aCoder: NSCoder) {
    //        aCoder.encode(company,     forKey: "company")
    //        aCoder.encode(desc, forKey: "desc")
    //        aCoder.encode(detail,    forKey: "detail")
    //
    //        aCoder.encode(website,     forKey: "website")
    //        aCoder.encode(sponsortype, forKey: "sponsortype")
    //        aCoder.encode(fblink,    forKey: "fblink")
    //
    //        aCoder.encode(twittername,     forKey: "twittername")
    //        aCoder.encode(linkedinlink, forKey: "linkedinlink")
    //        aCoder.encode(image,    forKey: "image")
    //
    //
    //        aCoder.encode(docLink,    forKey: "docLink")
    //        aCoder.encode(categories,     forKey: "categories")
    //        aCoder.encode(products, forKey: "products")
    //
    //        aCoder.encode(sponsor,    forKey: "sponsor")
    //    }
    
    // Mappable
    func mapping(map: Map) {
        company <- map["company"]
        desc <- map["description"]
        detail <- map["detail"]
        website <- map["website"]
        sponsortype <- map["sponsortype"]
        fblink <- map["fblink"]
        twittername <- map["twittername"]
        linkedinlink <- map["linkedinlink"]
        image <- map["image"]
        docLink <- map["docLink"]
        categories <- map["categories"]
        exhibitor_id <- map["exhibitor_id"]
    }
}

