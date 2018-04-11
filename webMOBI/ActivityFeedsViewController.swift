//
//  ActivityFeedsViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/2/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class ActivityFeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let defaults = UserDefaults.standard
    @IBOutlet weak var feedsTableView: UITableView!
    var AllFeeds : [ActivityFeeds] = []
    var pagenumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        self.title = "Feeds"
        
        //For white color title
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        feedsTableView.delegate = self
        let nib = UINib(nibName: "FeedsTableViewCell", bundle: nil)
        feedsTableView.register(nib, forCellReuseIdentifier: "FeedsTableViewCell")
        let nib1 = UINib(nibName: "FeedsTableViewCell1", bundle: nil)
        feedsTableView.register(nib1, forCellReuseIdentifier: "FeedsTableViewCell1")
        feedsTableView.separatorStyle = .none
        feedsTableView.estimatedRowHeight = 44
        feedsTableView.rowHeight = UITableViewAutomaticDimension
        feedsTableView.bounces = false
        getFeeds(postTime: "\(pagenumber)")
        initializeSockets()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        FeedsSockets.sharedInstance.closeConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setLeftNavigationBarItem()
            var image = UIImage(named: "createpost")
            image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightBtnAction))
        }
    }

    func rightBtnAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPostViewController") as! AddPostViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = AllFeeds[indexPath.row]
        if feed.attachments.count > 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsTableViewCell", for: indexPath) as! FeedsTableViewCell
            cell.selectionStyle = .none
            cell.postedViewForImages.viewWithTag(1)?.removeFromSuperview()
            cell.profileNameLabel.text = feed.username
            cell.postDescriptionTextView.text = feed.post_content
            cell.timeLabel.text = TimeConversion().localtimestringfrommilliseconds(ms: NSString(string: feed.create_time!).doubleValue, format: "hh:mm a")
            cell.likeButton2.setTitle("\(feed.likes!) Likes", for: .normal)
            cell.commentButton2.setTitle("\(feed.comments!) Comments", for: .normal)
            if (feed.profile_pic?.characters.count)! > 0{
                ImageLoadingWithCache().getImage(url: feed.profile_pic!, imageView:  cell.profilePicImageView, defaultImage: "EmptyUser.png")
            }else{
                cell.profilePicImageView.image = UIImage(named: "EmptyUser.png")
            }
            cell.likeButton1.tag = indexPath.row
            cell.likeButton1.addTarget(self, action: #selector(likeAction(sender:)), for: .touchUpInside)
            cell.likeButton2.tag = indexPath.row
            cell.likeButton2.addTarget(self, action: #selector(likeAction(sender:)), for: .touchUpInside)
            if feed.like_status == 0{
                cell.likeButton1.setImage(UIImage(named: "feedslike-o"), for: .normal)
            }else{
                cell.likeButton1.setImage(UIImage(named: "feedslike"), for: .normal)
            }
            cell.addImagesToView(images: feed.attachments)
            cell.commentButton1.tag = indexPath.row
            cell.commentButton1.addTarget(self, action: #selector(commentAction(sender:)), for: .touchUpInside)
            cell.commentButton2.tag = indexPath.row
            cell.commentButton2.addTarget(self, action: #selector(commentAction(sender:)), for: .touchUpInside)
//            let imageView = UIImageView()
//            imageView.frame = cell.postedViewForImages.bounds
//            imageView.image = UIImage(named: "sampleImage")
//            imageView.clipsToBounds = true
//            imageView.contentMode = .scaleAspectFill
//            imageView.tag = 1
//            cell.postedViewForImages.addSubview(imageView)
            cell.layoutIfNeeded()
            tableView.layoutIfNeeded()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsTableViewCell1", for: indexPath) as! FeedsTableViewCell1
            cell.selectionStyle = .none
            cell.profileNameLabel.text = feed.username
            cell.postDescriptionTextView.text = feed.post_content
            cell.timeLabel.text = TimeConversion().localtimestringfrommilliseconds(ms: NSString(string: feed.create_time!).doubleValue, format: "hh:mm a")
            cell.likeButton2.setTitle("\(feed.likes!) Likes", for: .normal)
            cell.commentButton2.setTitle("\(feed.comments!) Comments", for: .normal)
            if (feed.profile_pic?.characters.count)! > 0{
                ImageLoadingWithCache().getImage(url: feed.profile_pic!, imageView:  cell.profilePicImageView, defaultImage: "EmptyUser.png")
            }else{
                cell.profilePicImageView.image = UIImage(named: "EmptyUser.png")
            }
            cell.likeButton1.tag = indexPath.row
            cell.likeButton1.addTarget(self, action: #selector(likeAction(sender:)), for: .touchUpInside)
            if feed.like_status == 0{
                cell.likeButton1.setImage(UIImage(named: "feedslike-o"), for: .normal)
            }else{
                cell.likeButton1.setImage(UIImage(named: "feedslike"), for: .normal)
            }
            cell.commentButton1.tag = indexPath.row
            cell.commentButton1.addTarget(self, action: #selector(commentAction(sender:)), for: .touchUpInside)
            cell.layoutIfNeeded()
            tableView.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if feedsTableView.isDragging && (AllFeeds.count - 1) == indexPath.row{
            print("Yes, ", indexPath.row)
            getFeeds(postTime: (AllFeeds.last?.create_time)!)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        print("willDisplayFooterView")
    }
    
    func likeAction(sender: UIButton) {
        print("Liked")
        UIApplication.shared.beginIgnoringInteractionEvents()
        var likeStatus = 0
        if self.AllFeeds[sender.tag].like_status == 0{
            likeStatus = 1
            self.AllFeeds[sender.tag].like_status = 1
        }else{
            likeStatus = 0
            self.AllFeeds[sender.tag].like_status = 0
        }

        let selected_post = AllFeeds[sender.tag].toJSONString()
        FeedsSockets.sharedInstance.postLike(post_id: AllFeeds[sender.tag].post_id!, action: "like", comment_time: Date().millisecondsSince1970, like_status: likeStatus, index: sender.tag, selected_post: selected_post!)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func repeateCheck() {
        let socket = FeedsSockets.sharedInstance.socket
        if socket.status == .connected{
            print("connected")
        }else if socket.status == .connecting{
            print("connecting")
        }else if socket.status == .disconnected{
            print("disconnected")
        }else if socket.status == .notConnected{
            print("notConnected")
        }

    }
    
    func incrementCommentCount(cell: UITableViewCell, postID: Int) {
        for cnt in 0..<self.AllFeeds.count{
            if self.AllFeeds[cnt].post_id == UInt64(postID){
                self.AllFeeds[cnt].comments = self.AllFeeds[cnt].comments! + 1
                if cell is FeedsTableViewCell{
                    let cell1 = cell as! FeedsTableViewCell
                    cell1.commentButton2.setTitle("\(self.AllFeeds[cnt].comments!) Comments", for: .normal)
                }else if cell is FeedsTableViewCell1{
                    let cell1 = cell as! FeedsTableViewCell1
                    cell1.commentButton2.setTitle("\(self.AllFeeds[cnt].comments!) Comments", for: .normal)
                }
            }
        }
    }
    
    func initializeSockets() {
//        FeedsSockets.sharedInstance.establishConnection()
        FeedsSockets.sharedInstance.confirmConnection { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("its working ")
            })
        }
        FeedsSockets.sharedInstance.confirmCheckin { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("Connected")
            })
        }
        FeedsSockets.sharedInstance.didReceiveNewFeed { (feed) in
            DispatchQueue.main.async(execute: { () -> Void in
                print("Yes Received New Feed: ", feed)
                self.AllFeeds.insert(feed, at: 0)
                self.feedsTableView.reloadData()
            })
        }
        
        FeedsSockets.sharedInstance.newCommentForForFeedVC { (feed) in
            DispatchQueue.main.async(execute: { () -> Void in
                print("Yes Received New FeedComment: ", feed)
                let feed1 = ActivityFeeds(JSONString: String(describing: feed[0]))
                for cnt in 0..<self.AllFeeds.count{
                    if self.AllFeeds[cnt].post_id == feed1?.post_id{
                        self.AllFeeds[cnt].comments = self.AllFeeds[cnt].comments! + 1
                        self.feedsTableView.reloadData()
                    }
                }
            })
        }
        
        FeedsSockets.sharedInstance.LikeACK { (feed) in
            DispatchQueue.main.async(execute: { () -> Void in
                print(feed)
                let feed = ActivityFeeds(JSONString: String(describing: feed[1]))
                for cnt in 0..<self.AllFeeds.count{
                    if self.AllFeeds[cnt].post_id == feed?.post_id{
                        let like_status = feed?.like_status
                        if like_status == 0{
                            if self.AllFeeds[cnt].likes! > 0{
                                self.AllFeeds[cnt].likes = self.AllFeeds[cnt].likes! - 1
                                self.AllFeeds[cnt].like_status = 0
                                let cell = self.feedsTableView.cellForRow(at: IndexPath(row: cnt, section: 0))
                                self.setTheLikeForACK(cell: cell!, likeStatus: self.AllFeeds[cnt].like_status, likeCount: self.AllFeeds[cnt].likes!)
                            }
                        }else{
                            self.AllFeeds[cnt].likes = self.AllFeeds[cnt].likes! + 1
                            self.AllFeeds[cnt].like_status = 1
                            let cell = self.feedsTableView.cellForRow(at: IndexPath(row: cnt, section: 0))
                            self.setTheLikeForACK(cell: cell!, likeStatus: self.AllFeeds[cnt].like_status, likeCount: self.AllFeeds[cnt].likes!)
                        }
                    }
                }
                print("LikeACK")
            })
        }
        
        FeedsSockets.sharedInstance.didreceiveLikeOfFeed { (newFeedLike) in
            DispatchQueue.main.async(execute: { () -> Void in
                print("Yes Received New Like...!")
                for cnt in 0..<self.AllFeeds.count{
                    if self.AllFeeds[cnt].post_id == newFeedLike[1] as? UInt64{
                        if (newFeedLike[5] as? Int)! == 0{
                            if self.AllFeeds[cnt].likes! > 0{
                                self.AllFeeds[cnt].likes = self.AllFeeds[cnt].likes! - 1
//                                self.AllFeeds[cnt].like_status = 0
                                let cell = self.feedsTableView.cellForRow(at: IndexPath(row: cnt, section: 0))
                                self.setTheLikeForNewLike(cell: cell!, likeCount: self.AllFeeds[cnt].likes!)
                            }
                        }else{
                            self.AllFeeds[cnt].likes = self.AllFeeds[cnt].likes! + 1
//                            self.AllFeeds[cnt].like_status = 1
                            let cell = self.feedsTableView.cellForRow(at: IndexPath(row: cnt, section: 0))
                            self.setTheLikeForNewLike(cell: cell!, likeCount: self.AllFeeds[cnt].likes!)
                        }
                    }
                }
            })
        }
    }
    
    func BounceAnimation(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 2, y: 2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                       view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func rotateRight360Degrees(view: UIView, duration: CFTimeInterval) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = true
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = 1
        view.layer.add(rotateAnimation, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
            self.BounceAnimation(view: view)
        })
    }
    
    func rotateLeft360Degrees(view: UIView, duration: CFTimeInterval) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = CGFloat(Double.pi * 2)
        rotateAnimation.toValue = 0.0
        rotateAnimation.isRemovedOnCompletion = true
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = 1
        view.layer.add(rotateAnimation, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
            self.BounceAnimation(view: view)
        })
    }
    
    func setTheLikeForACK(cell : UITableViewCell, likeStatus: Int, likeCount: Int) {
        if cell is FeedsTableViewCell{
            let cell1 = cell as! FeedsTableViewCell
            if likeStatus == 0{
                cell1.likeButton1.setImage(UIImage(named: "feedslike-o"), for: .normal)
                cell1.likeButton2.setTitle("\(likeCount) Likes", for: .normal)
                rotateLeft360Degrees(view: cell1.likeButton1, duration: 0.4)
            }else{
                cell1.likeButton1.setImage(UIImage(named: "feedslike"), for: .normal)
                cell1.likeButton2.setTitle("\(likeCount) Likes", for: .normal)
                rotateRight360Degrees(view: cell1.likeButton1, duration: 0.4)
            }
        }else if cell is FeedsTableViewCell1{
            let cell1 = cell as! FeedsTableViewCell1
            if likeStatus == 0{
                cell1.likeButton1.setImage(UIImage(named: "feedslike-o"), for: .normal)
                cell1.likeButton2.setTitle("\(likeCount) Likes", for: .normal)
                rotateLeft360Degrees(view: cell1.likeButton1, duration: 0.4)
            }else{
                cell1.likeButton1.setImage(UIImage(named: "feedslike"), for: .normal)
                cell1.likeButton2.setTitle("\(likeCount) Likes", for: .normal)
                rotateRight360Degrees(view: cell1.likeButton1, duration: 0.4)
            }
        }
    }
    
    func setTheLikeForNewLike(cell : UITableViewCell, likeCount: Int) {
        if cell is FeedsTableViewCell{
            let cell1 = cell as! FeedsTableViewCell
            cell1.likeButton2.setTitle("\(likeCount) Likes", for: .normal)
        }else if cell is FeedsTableViewCell1{
            let cell1 = cell as! FeedsTableViewCell1
            cell1.likeButton2.setTitle("\(likeCount) Likes", for: .normal)
        }
    }
    
    func commentAction(sender: UIButton) {
        print("Commented")
        let FeedsCommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedsCommentViewController") as! FeedsCommentViewController
        FeedsCommentViewController.modalPresentationStyle = .fullScreen
        FeedsCommentViewController.modalTransitionStyle = .crossDissolve
        FeedsCommentViewController.postID = AllFeeds[sender.tag].post_id!
        FeedsCommentViewController.selectedPost = AllFeeds[sender.tag]
        self.present(FeedsCommentViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    func likeAPI(postID: UInt64, action: String, Comment: String, index: Int, button: UIButton) {
        
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
                                if self.AllFeeds[index].like_status == 1{
                                    self.AllFeeds[index].like_status = 0
                                }else{
                                    self.AllFeeds[index].like_status = 1
                                }
                                self.feedsTableView.reloadData()
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
    
    func getFeeds(postTime : String) {
        let userid = defaults.string(forKey: "EvntUserId")!
        let appid = self.defaults.string(forKey: "selectedappid")!
        let url = ServerApis.getFeeds + appid + "&userid=\(userid)" + "&last_post_time=\(postTime)"
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
                        print("json:\n",json["feeds"]!)
                        let feeds = Mapper<ActivityFeeds>().mapArray(JSONObject: json["feeds"])
                        for feed in feeds!{
                            self.AllFeeds.append(feed)
                        }
                        self.pagenumber = self.pagenumber + 1
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.feedsTableView.reloadData()
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
}
