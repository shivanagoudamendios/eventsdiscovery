//
//  FeedsSockets.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/10/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit
import SocketIO
import ObjectMapper

class FeedsSockets: NSObject {
    static let sharedInstance = FeedsSockets()
    let defaults = UserDefaults.standard
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: ServerApis.chatdomain)!,config: [
        "nsp": "/socket/con", "reconnectWait": 5,"forcePolling": true,
        ])
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.disconnect()
        socket.connect()
    }
    
    func confirmConnection(completionHandler: @escaping () -> Void) {
        socket.on("confirm_connection") {(dataArray, socketAck) -> Void in
            let appid = self.defaults.string(forKey: "selectedappid")!
            let userid = self.defaults.string(forKey: "EvntUserId")!
            let params = ["appid": appid as AnyObject,
                          "userid": userid as AnyObject
                ] as Dictionary<String, AnyObject>
            if(userid.length > 0) && (appid.length > 0)
            {
                self.socket.emit("feeds_checkin", params)
            }
            completionHandler()
        }
    }
    
    func confirmCheckin(completionHandler: @escaping () -> Void) {
        socket.on("confirm_feeds_checkin") {(dataArray, socketAck) -> Void in
            completionHandler()
        }
    }
    
    func didReceiveNewFeed(completionHandler: @escaping (_ feed: ActivityFeeds) -> Void) {
        socket.on("new_feed") {(feed_json) -> Void in
            print(feed_json)
            let feeds = Mapper<ActivityFeeds>().map(JSONObject: feed_json.0[0])
            completionHandler(feeds!)
        }
    }
    
    func postLike(post_id:UInt64, action: String, comment_time: Int64, like_status: Int, index: Int, selected_post: String ) {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let userid = self.defaults.string(forKey: "EvntUserId")!
        let profile_pic = self.defaults.string(forKey: "profile_pic")!
        let username = self.defaults.value(forKey: "name") as! String
        let params1 = ["like_status": like_status as AnyObject,
                       "post_id": post_id as AnyObject,
                       "index": index as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params1)
        self.socket.emit("post_like", appid, Int(post_id), userid, username, profile_pic, action, Double(comment_time), like_status, selected_post)
    }
    
    func LikeACK(completionHandler: @escaping (_ newfeedlike: NSArray) -> Void) {
        socket.on("post_like_ack") {(feed_json) -> Void in
            print(feed_json)
            completionHandler(feed_json.0 as NSArray)
        }
    }
    
    func didreceiveLikeOfFeed(completionHandler: @escaping (_ newfeedlike: NSArray) -> Void) {
        socket.on("new_like") {(feed_json) -> Void in
            print(feed_json)
            completionHandler(feed_json.0 as NSArray)
        }
    }
    
    func postCheckIn(post_id:UInt64) {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let userid = self.defaults.string(forKey: "EvntUserId")!
        let params = ["appid": appid as AnyObject,
                      "userid": userid as AnyObject,
                      "post_id": post_id as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        self.socket.emit("post_checkin", params)
    }
    
    func confirmPostCheckIn(completionHandler: @escaping () -> Void) {
        socket.on("confirm_post_checkin") {(feed_json) -> Void in
            print(feed_json)
            completionHandler()
        }
    }
    
    func postComment(post_id: UInt64, action: String, comment_time: Int64, comment: String,selected_post: String ) {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let userid = self.defaults.string(forKey: "EvntUserId")!
        let profile_pic = self.defaults.string(forKey: "profile_pic")!
        let username = self.defaults.value(forKey: "name") as! String
        self.socket.emit("post_comment", appid, Int(post_id), userid, username, profile_pic, action,Double(comment_time), comment, selected_post)
    }
    
    func CommentACK(completionHandler: @escaping (_ newcommentlike: NSArray) -> Void) {
        socket.on("post_comment_ack") {(feed_json) -> Void in
            print(feed_json)
            completionHandler(feed_json.0 as NSArray)
        }
        
    }
    
    func OffCommentACK() {
        socket.off("post_comment_ack")
    }
    
    func newCommentForForFeedVC(completionHandler: @escaping (_ newfeedlike: NSArray) -> Void) {
        socket.on("new_comment") {(feed_json) -> Void in
            print(feed_json)
            completionHandler(feed_json.0 as NSArray)
        }
    }
    
    func OffnewCommentForForFeedVC() {
        socket.off("new_comment")
    }
    
    func newCommentForCommentVC(completionHandler: @escaping (_ newfeedlike: NSArray) -> Void) {
        socket.on("new_post_comment") {(feed_json) -> Void in
            print(feed_json)
            completionHandler(feed_json.0 as NSArray)
        }
    }
    
    func OffnewCommentForCommentVC() {
        socket.off("new_post_comment")
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

