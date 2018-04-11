//
//  AttendeeDetailViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/28/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
class AttendeeDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var descriptiontextview: UITextView!
    @IBOutlet weak var blogurl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var ImgBackgroundView: UIView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var attendeeImg: UIImageView!
    @IBOutlet weak var attendeeTitle: UILabel!
    @IBOutlet weak var attendeefirstLtr: UILabel!
    @IBOutlet weak var attendeeDetails: UILabel!
    @IBOutlet weak var attendingInfoView: UIView!
    @IBOutlet weak var attendingInfoLabel: UILabel!
    @IBOutlet weak var connectToMsgView: UIView!
    @IBOutlet weak var connectToMsgLabel: UILabel!
    @IBOutlet weak var chtImg: UIImageView!
    @IBOutlet weak var nextImg: UIImageView!
    var ImgUrl : String = ""
    var attendeename : String = ""
    var attendeeDesc : String = ""
    var colorCode : UIColor?
    var attendeeId : String = ""
    let defaults = UserDefaults.standard
    var frompeoplejoined = false
    var descriptionfortextview = ""
    var blog_url = ""
    var urltoOpen = ""
    var appid = ""
    
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.isTranslucent = true
        //        self.navigationController?.view.backgroundColor = .clear
        
        
        //        backBtn.setBackgroundImage(UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-angle-left")!, textColor: UIColor.black, size: CGSize(width: 50, height: 50)), for: .normal)
        
        let backBtnTitle = String.fontAwesomeIcon(code: "fa-angle-left")
        
        backBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        backBtn.setTitle(backBtnTitle, for: .normal)
        backBtn.tintColor = UIColor.black
        
        backBtn.addTarget(self, action: #selector(self.backBtnAction), for: .touchUpInside)
        if frompeoplejoined{
            chtImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-comments-o")!, textColor: UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1) , size: CGSize(width: 30, height: 30))
        }else{
            let themeclr = defaults.string(forKey: "themeColor")
            chtImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-comments-o")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
        }
        nextImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-arrow-circle-o-right")!, textColor: UIColor.gray, size: CGSize(width: 30, height: 30))
        
        if(ImgUrl.characters.count > 0)
        {
            self.backgroundImg.backgroundColor = nil
            self.attendeefirstLtr.isHidden = true
            self.attendeeImg.isHidden = false
            DispatchQueue.main.async(execute: { () -> Void in
                //            let customUrl = self.ImgUrl + "?dt=" + self.getCurrentMillis().description
                ImageLoadingWithCache().getImage(url: self.ImgUrl, imageView:  self.backgroundImg, defaultImage: "EmptyUser.png")
                ImageLoadingWithCache().getImage(url: self.ImgUrl, imageView:  self.attendeeImg, defaultImage: "EmptyUser.png")
                
            })
        }else
        {
            self.attendeefirstLtr.isHidden = false
            self.attendeeImg.isHidden = true
            self.attendeefirstLtr.backgroundColor = colorCode
            self.backgroundImg.backgroundColor = colorCode
        }
        attendeeTitle.text = attendeename
        attendeefirstLtr.text = attendeename.first
        
        connectToMsgLabel.text = "Chat with " + attendeename
        if descriptionfortextview.characters.count > 0{
            descriptiontextview.attributedText = descriptionfortextview.html2AttributedStringWithFontSize(fontsize: 15)
        }else{
            descriptiontextview.text = "No Description"
            self.descriptiontextview.font = UIFont.systemFont(ofSize: 16)
        }
        
        self.descriptiontextview.textColor = UIColor.gray
        
        if blog_url.characters.count > 0{
            blogurl.text = blog_url
            urltoOpen = blog_url
        }else{
            blogurl.text = "No url"
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.openurl))
        blogurl.isUserInteractionEnabled = true
        blogurl.addGestureRecognizer(tap1)
        
        descriptiontextview.isUserInteractionEnabled = false

        if frompeoplejoined{
            attendingInfoLabel.text = "You're both attending "
        }else{
            attendingInfoLabel.text = "You're both attending " + self.defaults.string(forKey: "selectedAppName")!
        }
        
        attendeeDetails.text = attendeeDesc
        attendeefirstLtr.layer.cornerRadius = 50.0
        attendeefirstLtr.clipsToBounds = true
        attendeeImg.layer.cornerRadius = 50.0
        attendeeImg.clipsToBounds = true
        attendingInfoView.layer.cornerRadius = 5
        attendingInfoView.clipsToBounds = true
        attendingInfoView.layer.borderWidth = 0.5
        attendingInfoView.layer.borderColor = UIColor.lightGray.cgColor
        connectToMsgView.layer.borderWidth = 0.5
        connectToMsgView.layer.borderColor = UIColor.lightGray.cgColor
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundImg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundImg.addSubview(blurEffectView)
        
        self.backgroundImg.bringSubview(toFront: attendeefirstLtr)
        self.backgroundImg.bringSubview(toFront: attendeeImg)
        self.backgroundImg.bringSubview(toFront: attendeeTitle)
        self.backgroundImg.bringSubview(toFront: attendeeDetails)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.gotoChat))
        tap.delegate = self
        self.connectToMsgView.addGestureRecognizer(tap)
        
    }
    
    func openurl() {
        if urltoOpen.characters.count > 0{
            if urltoOpen.contains("http"){
                if let url = URL(string: urltoOpen) {
                    UIApplication.shared.openURL(url)
                }
            }else{
                let socialURL = "http://" + urltoOpen
                if let url = URL(string: socialURL) {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func gotoChat(sender : UIButton)
    {
        SocketIOManager.sharedInstance.establishConnection()
        SocketIOManager.sharedInstance.reconnect { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                print("its connected")
            })
        }
        let ChatView = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        ChatView.username = attendeename
        ChatView.toUserId = attendeeId
        ChatView.toname = attendeename
        if frompeoplejoined{
            ChatView.frompeoplejoined = true
            ChatView.appid = appid
        }
        self.navigationController?.pushViewController(ChatView, animated: true)
    }
    
    func backBtnAction(sender : UIButton){
        self.navigationController?.navigationBar.isHidden = false
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
