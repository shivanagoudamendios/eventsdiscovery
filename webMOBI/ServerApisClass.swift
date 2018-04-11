//
//  ServerApisClass.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 7/5/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import Foundation

public struct ServerApis {
    
//        public static let domain = "http://159.203.78.208:82/"
//    public static let domain = "https://www.webmobicrm.com/"
//     public static let domain = "http://192.168.1.18:82/"
    
    //multiEvent Urls
 //   public static let domain = "http://104.131.76.15:3000/"
    
//    public static let setmycategories = domain+"api/events/v1/events/setmycategories"
    public static let getmycategories = domain+"api/events/v1/events/getmycategories?"
//    public static let attendEventUrl = domain+"api/events/v1/events/regevent?"
//    public static let DiscoveryUrl = domain+"api/events/v1/events/search?city="
//    public static let nearbyUrl = domain+"api/events/v1/events/distancedevents"
//    public static let popularUrl = domain+"api/events/v1/events/myinterest"
//    public static let RecommendedUrl = domain+"api/multievent/v1/recommended"
//    public static let eventsCategoryUrl = domain+"api/multievent/v1/category_events?category="
//    public static let eventsearchUrl = domain+"api/multievent/v1/eventsearch?q="
//    public static let UserRegisterUrl = domain+"api/events/v1/user/register"
//    public static let UserLoginUrl = domain+"api/events/v1/user/login"
//    public static let forgotPasswdUrl = domain+"api/events/v1/events/forgotpwd"
//    public static let ProfileupdateUrl = domain+"api/user/v1/updateprofile"
//    public static let ChangepasswordUrl = domain+"api/user/v1/changepassword"
//    public static let DownloadcountUrl = domain+"api/v1/update/downloadincrease"
    public static let myeventsUrl = domain+"api/events/v1/events/myevents"
//    public static let filterBasedSearchUrl = domain+"api/events/v1/events/search"
//    public static let getVisitorsUrl = domain+"api/events/v1/events/getvisitors?eventid="
//    public static let sendNeweventUrl = domain+"api/events/v1/events/addevent"
//    
//    //single event Urls
//    public static let GetAppFavEventUrl = domain+"api/v1/getappfavrtagenda?"
//    public static let PostAppFavEventUrl = domain+"api/v1/appfavrtagenda"
//    public static let RemoveAppFavEventUrl = domain+"api/v1/deleteappfavrtagenda"
//    
//    public static let GetAppFavCompanyUrl = domain+"api/v1/getappfavrtcompanies?"
//    public static let PostAppFavCompanyUrl = domain+"api/v1/appfavrtcompany"
//    public static let RemoveAppFavCompanyUrl = domain+"api/v1/deleteappfavrtcompanies"
//    
    public static let AppNotificationUrl = domain+"api/richpush/v2/notifications?"
//    //    public static let AppContactUsUrl = "http://www.webmobicrm.com/api/richpush/v1/eventcontactus"
//    public static let AppContactUsUrl = domain+"api/richpush/v1/feedback"
    public static let AppointmentUrl = domain+"richpush/v1/createschedule"
//    public static let EventRegisterUrl = domain+"api/events/v2/user/login"
//    public static let postRatingsessionUrl = domain+"api/richpush/v1/getratesession"
//    public static let postUserRatingUrl = domain+"api/richpush/v1/ratespeaker"
//    public static let GetRatingsessionUrl = domain+"api/richpush/v1/getratesession?"
//    public static let GetUserRatingUrl = domain+"api/richpush/v1/getratespeaker?"
//    public static let chattingUsersUrl = domain+"api/richpush/v1/getchatusers?appId="
//    public static let SurveyFeedbackUrl = domain+"api/v1/appfeedback"
//    public static let pollingUrl = domain+"api/v1/pollfeedback"
//    public static let historyChatUrl = domain+"api/richpush/v1/getchathistory?appId="
//    public static let getlatestversionUrl = domain+"api/events/v2/user/jsonversion?appId="
//    public static let getslotScheduleUrl = domain+"api/user/v1/slotschedule?"
//    public static let postslotScheduleUrl = domain+"api/user/v1/slotschedule"
//    public static let postdeclineslotScheduleUrl = domain+"api/user/v1/deleteslotschedule"
    public static let getActivityFeedsUrl = "http://192.168.1.23:82/"+"api/richpush/v1/getfeeds?"
    public static let getpostLikesUrl = "http://192.168.1.23:82/"+"api/richpush/v1/getreviews?"
    public static let postcommentsLikesUrl = "http://192.168.1.23:82/"+"api/richpush/v1/postreviews"
    public static let postfeedsUrl = "http://192.168.1.23:82/"+"api/richpush/v1/postfeeds"
    
//    public static let domain = "http://159.203.78.208:3000"
//    public static let chatdomain = "http://159.203.78.208:3030"

    // Production
    public static let domain = "https://api.webmobi.com"
    public static let chatdomain = "https://chat.webmobi.com"

    // Development
//       public static let domain = "http://104.131.76.15:3000"
//       public static let chatdomain = "http://104.131.76.15:3030"
//
    
    public static let UserRegisterUrl = domain+"/api/user/single_event_register"
    public static let UserLoginUrl = domain+"/api/user/single_event_login"
    public static let UserLoginUrl_public = domain+"/api/user/checkin"
    public static let forgotPasswdUrl = domain+"/api/user/forgot_password"
    public static let AppContactUsUrl = domain+"/api/user/contact_us"
    public static let ScheduleUrl = domain+"/api/event/manage_schedule"
    public static let FavoriteUrl = domain+"/api/event/manage_favorites"
    public static let NotesUrl = domain+"/api/event/manage_notes"                   //
    public static let AttendeesUrl = domain+"/api/user/discovery_app_users?appid="  //
    public static let chattingUsersUrl = chatdomain + "/get_chat_users?appid=";
    public static let historyChatUrl = chatdomain+"/get_chat_history?appid="
    public static let SurveyFeedbackUrl = domain+"/api/event/appfeedback"
    public static let pollingUrl = domain+"/api/event/pollfeedback"
    public static let getlatestversionUrl = domain+"/api/event/jsonversion?appId="
    public static let GetRatingUrl = domain+"/api/event/getratings?appid="             //
    public static let SetRatingUrl = domain+"/api/event/ratings"                       //
    public static let GetProfileUrl = domain+"/api/user/profile?userid="               //
    public static let ProfileupdateUrl = domain+"/api/user/update_profile"                //
    public static let UpdateProfilePic = domain + "/api/user/profile_photo"         //
    public static let ChangepasswordUrl = domain+"/api/user/change_password"
    public static let Logout = domain+"/api/user/logout"                            //
    public static let syncUrl = domain + "/api/user/offline_sync"
    public static let notificationUrl = domain + "/api/event/notifications?appid="
    public static let clearnotifyBadge = chatdomain + "/clear_notifications"
    public static let businessCard = domain + "/api/user/usercontactupload"
    public static let getfeedAction = domain + "/api/event/get_feed_actions?appid="
    public static let feedAction = domain + "/api/event/feed_action"
    public static let getFeeds = domain + "/api/event/get_feeds?appid="
    public static let postFeeds = domain + "/api/event/post_feed"
    public static let getContacts = domain + "/api/user/contacts?userid="
    public static let getleaderboard = domain + "/api/event/leaderboard"
    
}


