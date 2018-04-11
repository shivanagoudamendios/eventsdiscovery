//
//  FeedsCommentViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/5/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class FeedsCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var CommentViewBottomHeight: NSLayoutConstraint!
    
    let defaults = UserDefaults.standard
    var AllComments : [CommentFeeds] = []
    var postID : UInt64 = 0
    var selectedPost : ActivityFeeds!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        commentTextView.text = "Write a Comment"
        commentTextView.textColor = UIColor.gray
        commentTableView.delegate = self
        let nib = UINib(nibName: "FeedsCommentsTableViewCell", bundle: nil)
        commentTableView.register(nib, forCellReuseIdentifier: "FeedsCommentsTableViewCell")
        commentTableView.estimatedRowHeight = 108
        commentTableView.rowHeight = UITableViewAutomaticDimension
//        commentTableView.bounces = false
        getCommentFeeds(postID: postID)
        sendButton.isUserInteractionEnabled = false
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        let themeclr =  UserDefaults.standard.string(forKey: "themeColor")
        //For white color title
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: themeclr!)
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.characters.count > 0{
            sendButton.isUserInteractionEnabled = true
        }else{
            sendButton.isUserInteractionEnabled = false
        }
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func keyboardOnScreen(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.CommentViewBottomHeight.constant = keyboardFrame.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.text = ""
        commentTextView.textColor = UIColor.black
    }
    
    func keyboardOffScreen(notification: NSNotification) {
        self.CommentViewBottomHeight.constant = 0
        self.view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        FeedsSockets.sharedInstance.postCheckIn(post_id: postID)
        FeedsSockets.sharedInstance.confirmPostCheckIn {
            DispatchQueue.main.async {
                print("confirmPostCheckIn")
            }
        }
        FeedsSockets.sharedInstance.CommentACK { (arra) in
            DispatchQueue.main.async {
                print(arra)
                var newComment : [String: Any] = [:]
                newComment["appid"] = (arra[1] as! String)
                newComment["post_id"] = arra[2] as! Int
                newComment["userid"] = (arra[3] as! String)
                newComment["username"] = (arra[4] as! String)
                newComment["profile_pic"] = (arra[5] as! String)
                newComment["comment_time"] = arra[7] as! Double
                newComment["comment"] = (arra[8] as! String)
                let commentData : CommentFeeds = Mapper<CommentFeeds>().map(JSON: newComment)!
                print(newComment)
                self.AllComments.append(commentData)  //.insert(commentData, at: 0)
                self.commentTableView.reloadData()
            }
        }
        FeedsSockets.sharedInstance.newCommentForCommentVC { (arra) in
            DispatchQueue.main.async {
                print(arra)
                var newComment : [String: Any] = [:]
                newComment["appid"] = (arra[0] as! String)
                newComment["post_id"] = arra[1] as! Int
                newComment["userid"] = (arra[2] as! String)
                newComment["username"] = (arra[3] as! String)
                newComment["profile_pic"] = (arra[4] as! String)
                newComment["comment_time"] = arra[6] as! Double
                newComment["comment"] = (arra[7] as! String)
                let commentData : CommentFeeds = Mapper<CommentFeeds>().map(JSON: newComment)!
                print(newComment)
                self.AllComments.append(commentData) // insert(commentData, at: 0)
                self.commentTableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FeedsSockets.sharedInstance.OffCommentACK()
        FeedsSockets.sharedInstance.OffnewCommentForCommentVC()
        FeedsSockets.sharedInstance.OffnewCommentForForFeedVC()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func commentAction(_ sender: UIButton) {
        print("Comment")
        self.view.endEditing(true)
        if FeedsSockets.sharedInstance.socket.status == .connected{
            commentTextView.textColor = UIColor.gray
            FeedsSockets.sharedInstance.postComment(post_id: postID, action: "comment", comment_time: Date().millisecondsSince1970, comment: commentTextView.text! , selected_post: selectedPost.toJSONString()!)
            commentTextView.text = "Write a Comment"
        }else{
            print("Socket Diosconnected...")
        }
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AllComments.count > 0{
            return AllComments.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsCommentsTableViewCell", for: indexPath) as! FeedsCommentsTableViewCell
        cell.commentTextView.text = AllComments[indexPath.row].comment
        if (AllComments[indexPath.row].profile_pic?.characters.count)! > 0{
            ImageLoadingWithCache().getImage(url: AllComments[indexPath.row].profile_pic!, imageView:  cell.profileImageView, defaultImage: "EmptyUser.png")
        }else{
            cell.profileImageView.image = UIImage(named: "EmptyUser.png")
        }
        cell.profileName.text = AllComments[indexPath.row].username
        cell.timeLabel.text = TimeConversion().localtimestringfrommilliseconds(ms:  AllComments[indexPath.row].comment_time!, format: "hh:mm a")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func getCommentFeeds(postID : UInt64) {
        let appid = self.defaults.string(forKey: "selectedappid")!
        let url = ServerApis.getfeedAction + appid + "&post_id=\(postID)" + "&action=comment"
        print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error!)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: (error! as NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String: Any]
                    if ((json["response"] as! Bool) == true){
                        let feeds = Mapper<CommentFeeds>().mapArray(JSONObject: json["comments"])
                        print(feeds!)
                        self.AllComments = feeds!.reversed()
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.commentTableView.reloadData()
                            })
                        })
                    }else{
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                let alert = UIAlertController(title: "Request Failed", message: "Try agin!", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "Request Failed", message: "Rating could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: "Rating could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        task.resume()
        
    }
    
    func postComment(postID: String, action: String, Comment: String, index: Int, button: UIButton) {
        
        let appid = self.defaults.string(forKey: "selectedappid")
        let userid = defaults.string(forKey: "EvntUserId")!
        
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.feedAction)! as URL)
        request.httpMethod = "POST"
        let params = ["appid": appid as AnyObject,
                      "userid": userid as AnyObject,
                      "post_id": postID as AnyObject,
                      "action": action as AnyObject,
                      "comment": Comment as AnyObject,
                      "comment_time": Date().millisecondsSince1970 as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error!)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        if UserDefaults.standard.bool(forKey: "didsync") == false{
                            UserDefaults.standard.set(true, forKey: "didsync")
                        }
                        let alert = UIAlertController(title: "Request Failed", message: (error! as NSError).localizedDescription + " Currently saved offline and will be synced when internet available", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200){
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! [String: Any]
                    print(json)
                    if ((json["response"] as! Bool) == true){
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                let alert = UIAlertController(title: "SUCCESS", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                let alert = UIAlertController(title: "Request Failed", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    self.dismiss(animated: true, completion: nil)
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        task.resume()
    }
    
    


}
