//
//  Attendee.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/20/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import ObjectMapper

class Attendee: NSObject,Mappable,NSCoding {
    public func encode(with aCoder: NSCoder) {
        
    }
    
    var company : String? = ""
    var designation : String? = ""
    var email : String? = ""
    var first_name  : String? = ""
    var last_name : String? = ""
    var profile_pic : String? = ""
    var userid : String? = ""
    var desc : String? = ""
    var blogurl : String? = ""
    
    
    required init?(map: Map) {
        
    }
    
    
    init(company: String, designation: String,email: String,first_name: String,last_name: String,profile_pic: String,userid: String,desc: String,blogurl: String) {
        self.company = company
        self.designation = designation
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.profile_pic = profile_pic
        self.userid = userid
        self.desc = desc
        self.blogurl = blogurl
        
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let company = aDecoder.decodeObject(forKey: "company"),
            let designation = aDecoder.decodeObject(forKey: "designation"),
            let email = aDecoder.decodeObject(forKey: "email"),
            let first_name = aDecoder.decodeObject(forKey: "first_name"),
            let last_name = aDecoder.decodeObject(forKey: "last_name"),
            let profile_pic = aDecoder.decodeObject(forKey: "profile_pic"),
            let userid = aDecoder.decodeObject(forKey: "userid"),
            let desc = aDecoder.decodeObject(forKey: "desc"),
            let blogurl = aDecoder.decodeObject(forKey: "blogurl")
            else{
                return nil
        }
        self.init(company: company as! String, designation: designation as! String,email: email as! String,first_name: first_name as! String,last_name: last_name as! String,profile_pic: profile_pic as! String,userid: userid as! String,desc: desc as! String,blogurl: blogurl as! String)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(company,     forKey: "company")
        aCoder.encode(designation, forKey: "designation")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(profile_pic, forKey: "profile_pic")
        aCoder.encode(userid, forKey: "userid")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(blogurl, forKey: "blogurl")
    }
    
    
    // Mappable
    func mapping(map: Map) {
        company <- map["company"]
        designation <- map["designation"]
        email <- map["email"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        profile_pic <- map["profile_pic"]
        userid <- map["userid"]
        desc <- map["description"]
        blogurl <- map["user_blog"]
    }
}
