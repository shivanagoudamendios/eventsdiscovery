//
//  ServerAPIs.swift
//  webMOBI
//
//  Created by webmobi on 7/11/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import Foundation

public struct ServerAPIs {
    
    //DOMAIN
    public static let domain = "https://api.webmobi.com/"
    
    //DEVELOPMENT
//   public static let domain = "http://104.131.76.15:3000/"
//    public static let domain = "http://159.203.78.208:3000/"
    public static let category = domain + "api/event/category_events?category="
    
    //USERS CONNECTIONS
    public static let discovery_register = domain + "api/user/discovery_register"
    public static let discovery_signup = domain+"api/user/register"
    public static let discovery_login = domain + "api/user/login"
    public static let forgot_password = domain+"api/user/forgot_password"
    public static let get_joined_people = domain+"api/user/discovery_app_users?"
    public static let discovery_social_media_connect = domain+"api/user/social_media_connect"
    public static let device_app = domain+"api/user/device_app"
    
    //EVENTS
    public static let recommended_event = domain+"api/event/recommended_events?"
    public static let nearby_events = domain+"api/event/nearby_events"
    public static let get_popular_events = domain+"api/event/popular_events"
    public static let event_search = domain+"api/event/event_search?q="
    public static let private_event_search = domain+"api/event/private_event_search?q="

    //CATEGORY EVENTS
    public static let category_trade_show = category+"Trade%20Show%20and%20Events"
    public static let category_schools = category+"Schools"
    public static let category_community_center = category+"Community%20Centers"
    public static let category_museums = category+"Museums"
    public static let category_personal_events = category+"Personal%20Events"
    public static let category_associations = category+"Associations"
    public static let category_airports = category+"Airports"
    public static let category_national_parks = category+"National%20Park"

}
