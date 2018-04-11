//
//  SocketIOManager.swift
//  SocketChat
//

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    let defaults = UserDefaults.standard
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: ServerApis.chatdomain)!,config: [
        "nsp": "/socket/con","reconnectWait": 5,"forcePolling": true,
        ])
    
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
        
    }
    //    func establishConnection(user_id:String) {
    //        socket.emit("checkin", user_id)
    //    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    //
    //    func connectToServerWithNickname(nickname: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
    //        socket.emit("connectUser", nickname)
    //
    //        socket.on("userList") { ( dataArray, ack) -> Void in
    //            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
    //        }
    
    //        listenForOtherMessages()
    //    }
    
    
    //    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
    //        socket.emit("exitUser", nickname)
    //        completionHandler()
    //    }
    
    
    func sendMessage(To_UserID:String,To_UserName:String,From_UserID:String,From_UserName:String,appid:String,appname:String,chat_type:String,TimeinMilli:String,msg:String,msg_datatype:String) {
        socket.emit("message", To_UserID,To_UserName,From_UserID,From_UserName,appid,appname,chat_type,TimeinMilli,msg,msg_datatype)
    }
    
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("message") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["id"] = dataArray[0] as! String as AnyObject?
            messageDictionary["msg"] = dataArray[1] as! String as AnyObject?
            messageDictionary["From_UserID"] = dataArray[2] as! String as AnyObject?
            messageDictionary["From_UserName"] = dataArray[3] as! String as AnyObject?
            messageDictionary["appid"] = dataArray[4] as! String as AnyObject?
            messageDictionary["TimeinMilli"] = dataArray[6] as! String as AnyObject?
            messageDictionary["msg_datatype"] = dataArray[7] as! String as AnyObject?
            
            if !self.defaults.bool(forKey: "checklivechat") && !self.defaults.bool(forKey: "notificationfire")
            {
                let notification = UILocalNotification()
                notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
                notification.alertBody = dataArray[0] as? String
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.userInfo = ["appId": dataArray[2] as! String,"email":dataArray[1] as! String]
                UIApplication.shared.scheduleLocalNotification(notification)
                
                self.defaults.set(true, forKey: "notificationfire")
                
            }
            
            
            completionHandler(messageDictionary)
        }
    }
    
    func sentChatMessage(completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("msg_ack") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            if(dataArray.count >= 6)
            {
                messageDictionary["id"] = dataArray[0] as! String as AnyObject?
                messageDictionary["msg"] = dataArray[1] as! String as AnyObject?
                messageDictionary["From_UserID"] = dataArray[2] as! String as AnyObject?
                messageDictionary["From_UserName"] = dataArray[3] as! String as AnyObject?
                messageDictionary["appid"] = dataArray[4] as! String as AnyObject?
                messageDictionary["TimeinMilli"] = dataArray[6] as! String as AnyObject?
                messageDictionary["msg_datatype"] = dataArray[7] as! String as AnyObject?
                completionHandler(messageDictionary)
            }
            
        }
    }
    
    func confirmCheckin(completionHandler: @escaping () -> Void) {
        socket.on("confirm_checkin") {(dataArray, socketAck) -> Void in
            completionHandler()
        }
    }
    
    
    func reconnect(completionHandler: @escaping () -> Void) {
        socket.on("confirm_connection") {(dataArray, socketAck) -> Void in
            if let userid = self.defaults.string(forKey: "EvntUserId"){
                if(userid.length > 0)
                {
                    self.socket.emit("checkin", userid)
                }
            }
            completionHandler()
        }
    }
    
    
    //    private func listenForOtherMessages() {
    //        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
    //            NSNotificationCenter.defaultCenter().postNotificationName("userWasConnectedNotification", object: dataArray[0] as! [String: AnyObject])
    //        }
    //
    //        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
    //            NSNotificationCenter.defaultCenter().postNotificationName("userWasDisconnectedNotification", object: dataArray[0] as! String)
    //        }
    //
    //        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
    //            NSNotificationCenter.defaultCenter().postNotificationName("userTypingNotification", object: dataArray[0] as? [String: AnyObject])
    //        }
    //    }
    
    
    //    func sendStartTypingMessage(nickname: String) {
    //        socket.emit("startType", nickname)
    //    }
    //    
    //    
    //    func sendStopTypingMessage(nickname: String) {
    //        socket.emit("stopType", nickname)
    //    }
}
