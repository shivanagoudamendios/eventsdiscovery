//
//  SponersandExhibitorsDetailViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/21/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import FontAwesome_swift
import MBProgressHUD

class SponersandExhibitorsDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var titlendUrlView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addNotesView: UIView!
    @IBOutlet weak var AddNotesBtn: UIButton!
    @IBOutlet weak var addNotesLabel: UILabel!
    @IBOutlet weak var DescTextView: UITextView!
    @IBOutlet weak var addFavView: UIView!
    @IBOutlet weak var addFavLabel: UILabel!
    
    let defaults = UserDefaults.standard
    let cache = ImageLoadingWithCache()
    var spnsorDetails : SponsorsDataItems?
    var exhibitorDetails : ExhibitorsDataItems?
    var fromSponsor: Bool = false
    var favList : [Int64] = []
    var noteType = ""
    var noteName = ""
    var noteID : Int64  = 0
    var categoryColor = ""
    var hud = MBProgressHUD()
    var fromFav = false
    var urltoOpen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.titlendUrlView.layer.borderColor = UIColor.lightGray.cgColor
        self.titlendUrlView.layer.borderWidth = 0.5
        self.addNotesView.layer.borderColor = UIColor.lightGray.cgColor
        self.addNotesView.layer.borderWidth = 0.5
        self.addFavView.layer.borderColor = UIColor.lightGray.cgColor
        self.addFavView.layer.borderWidth = 0.5
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(self.openurl))
        urlLabel.isUserInteractionEnabled = true
        urlLabel.addGestureRecognizer(tap0)
        if(fromSponsor){

            let imgurl = (spnsorDetails?.image!)
            if( imgurl != nil ){
                DispatchQueue.main.async() { () -> Void in
                    self.cache.getImage(url: imgurl!, imageView:  self.ImgView, defaultImage: "NoImage")
                }
            }
            titleLabel.text = spnsorDetails?.company
            urlLabel.text = spnsorDetails?.website
            urltoOpen = (spnsorDetails?.website)!
            DescTextView.text = spnsorDetails?.detail?.html2String
            DescTextView.font = UIFont.systemFont(ofSize: 13)
            setColorIndecater(color: categoryColor, inputtxt: (spnsorDetails?.categories)!,fontawsomecode: "fa-circle")
            noteType = "fromSponsors"
            noteID = (spnsorDetails?.sponsor_id)!
            noteName = (spnsorDetails?.company)!
            let appid = self.defaults.string(forKey: "selectedappid")
            let idToStore = "\(appid!)\(spnsorDetails!.sponsor_id!)"
            if CoreDataManager.checkSponsorsInFavorites(id: idToStore)
            {
                addFavLabel.text = "REMOVE FROM FAVORITE"
            }else{
                addFavLabel.text = "ADD TO FAVORITE"
            }
            
        }else
        {
            favList = CoreDataManager.GetAllExhibitorFavorites()
            let imgurl = (exhibitorDetails?.image!)
            if( imgurl != nil ){
                DispatchQueue.main.async() { () -> Void in
                    self.cache.getImage(url: imgurl!, imageView:  self.ImgView, defaultImage: "NoImage")
                }
            }
            titleLabel.text = exhibitorDetails?.company
            urlLabel.text = exhibitorDetails?.website
            urltoOpen = (exhibitorDetails?.website)!
            DescTextView.text = exhibitorDetails?.detail?.html2String
            DescTextView.font = UIFont.systemFont(ofSize: 13)
            setColorIndecater(color: categoryColor, inputtxt: (exhibitorDetails?.categories)!,fontawsomecode: "fa-circle")
            noteType = "fromExhibitors"
            noteID = (exhibitorDetails?.exhibitor_id)!
            noteName = (exhibitorDetails?.company)!
            if(favList.contains(exhibitorDetails!.exhibitor_id!))
            {
                addFavLabel.text = "REMOVE FROM FAVORITE"
            }else{
                addFavLabel.text = "ADD TO FAVORITE"
            }
        }
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            addNotesLabel.textColor = UIColor(hex:themeclr)
            AddNotesBtn.setBackgroundImage(UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-pencil-square-o")!, textColor: UIColor(hex:themeclr), size: CGSize(width: 25, height: 25)), for: .normal)
            addFavLabel.textColor = UIColor(hex:themeclr)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        addNotesView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(sender:)))
        addFavView.addGestureRecognizer(tap1)
        
    }
    
    func openurl() {
        if urltoOpen.characters.count > 0{
            
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
            //UIApplication.shared.openURL(NSURL(string: urltoOpen)! as URL)
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
        vc.NoteType = noteType
        vc.NoteID = noteID
        vc.NoteName = noteName
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleTap1(sender: UITapGestureRecognizer) {
        
        var Mark = ""
        var Type = ""
        let appid = self.defaults.string(forKey: "selectedappid")
        let token = defaults.string(forKey: "token")
        let UserId = self.defaults.string(forKey: "EvntUserId")
        var idToStore = ""
        if (defaults.bool(forKey: "login"))
        {
            let appid = self.defaults.string(forKey: "selectedappid")
            if(self.fromSponsor){
                idToStore = "\(appid!)\(self.spnsorDetails!.sponsor_id!)"
                if CoreDataManager.checkSponsorsInFavorites(id: idToStore)
                {
                    Mark = "unmark"
                    CoreDataManager.RemoveSponsorsFromFavorites(id: idToStore)
                }else{
                    Mark = "mark"
                    CoreDataManager.AddSponsorsToFavorites(id: idToStore, eventid: (Int64(self.spnsorDetails!.sponsor_id!)))
                }
                Type = "Sponsor"
            }else
            {
                idToStore = "\(appid!)\(self.exhibitorDetails!.exhibitor_id!)"
                if CoreDataManager.checkExhibitorInFavorites(id: idToStore)
                {
                    Mark = "unmark"
                    CoreDataManager.RemoveExhibitorFromFavorites(id: idToStore)
                }else{
                    Mark = "mark"
                    CoreDataManager.AddExhibitorToFavorites(id: idToStore, eventid: (Int64(self.exhibitorDetails!.exhibitor_id!)))
                }
                Type = "Exhibitor"
            }
            self.hud.hide(true, afterDelay: 0)
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.labelText = "Processing..."
            hud.minSize = CGSize(width: 150, height: 100)
            
            let request = NSMutableURLRequest(url: NSURL(string: ServerApis.FavoriteUrl)! as URL)
            request.httpMethod = "POST"
            
            let params = ["appid": appid as AnyObject,
                          "userid":UserId as AnyObject,
                          "action": Mark as AnyObject,
                          "type": Type as AnyObject,
                          "favorites": favList.description as AnyObject
                ] as Dictionary<String, AnyObject>
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(token, forHTTPHeaderField: "Token")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    if(self.fromSponsor){
                        if CoreDataManager.checkSponsorsInFavorites(id: idToStore){
                            CoreDataManager.RemoveSponsorsFromFavorites(id: idToStore)
                        }
                    }else{
                        if CoreDataManager.checkExhibitorInFavorites(id: idToStore){
                            CoreDataManager.RemoveExhibitorFromFavorites(id: idToStore)
                        }
                    }
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            let alert = UIAlertController(title: "Request Failed", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                    
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    if(self.fromSponsor){
                        if CoreDataManager.checkSponsorsInFavorites(id: idToStore){
                            CoreDataManager.RemoveSponsorsFromFavorites(id: idToStore)
                        }
                    }else{
                        if CoreDataManager.checkExhibitorInFavorites(id: idToStore){
                            CoreDataManager.RemoveExhibitorFromFavorites(id: idToStore)
                        }
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            UIAlertView(title: "Request Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                }
                
                do {
                    let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print("responseString = \(jsonResult) ")
                    let response = (jsonResult["response"] as? Bool)!
                    let responseString = (jsonResult["responseString"] as? String)!
                    if(response == true)
                    {
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                if(self.fromFav){
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                            })
                        })
                        
                    }else
                    {
                        if(self.fromSponsor){
                            if CoreDataManager.checkSponsorsInFavorites(id: idToStore){
                                CoreDataManager.RemoveSponsorsFromFavorites(id: idToStore)
                            }
                        }else{
                            if CoreDataManager.checkExhibitorInFavorites(id: idToStore){
                                CoreDataManager.RemoveExhibitorFromFavorites(id: idToStore)
                            }
                        }
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.hud.hide(true, afterDelay: 0)
                                if UserDefaults.standard.bool(forKey: "didsync") == false{
                                    UserDefaults.standard.set(true, forKey: "didsync")
                                }
                                UIAlertView(title: "Request Field",message:responseString ,delegate: nil,cancelButtonTitle: "OK").show()
                                
                            })
                        })
                        
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                        })
                    })
                }catch
                {
                    print("error")
                    if(self.fromSponsor){
                        if CoreDataManager.checkSponsorsInFavorites(id: idToStore){
                            CoreDataManager.RemoveSponsorsFromFavorites(id: idToStore)
                        }
                    }else{
                        if CoreDataManager.checkExhibitorInFavorites(id: idToStore){
                            CoreDataManager.RemoveExhibitorFromFavorites(id: idToStore)
                        }
                    }
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.hud.hide(true, afterDelay: 0)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            UIAlertView(title: "Request Failed",message:"Check connection and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
                        })
                    })
                    
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    if(self.fromSponsor){
                        if CoreDataManager.checkSponsorsInFavorites(id: idToStore){
                            self.addFavLabel.text = "REMOVE FROM FAVORITE"
                        }else{
                            self.addFavLabel.text = "ADD TO FAVORITE"
                        }
                    }else{
                        if CoreDataManager.checkExhibitorInFavorites(id: idToStore){
                            self.addFavLabel.text = "REMOVE FROM FAVORITE"
                        }else{
                            self.addFavLabel.text = "ADD TO FAVORITE"
                        }
                    }
                })
            }
            task.resume()
            
        }else
        {
            UIAlertView(title: "Request Failed",message:"Please login and try again" ,delegate: nil,cancelButtonTitle: "OK").show()
        }
    }
    
    
    func setColorIndecater( color : String,inputtxt : String ,fontawsomecode : String)
    {
        let attachment = NSTextAttachment()
        attachment.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode(fontawsomecode)!, textColor: UIColor(hex:color), size: CGSize(width: 15, height: 15))
        let offsetY: CGFloat = -2.0
        attachment.bounds = CGRect(x: CGFloat(0), y: offsetY, width: CGFloat((attachment.image?.size.width)!), height: CGFloat((attachment.image?.size.height)!))
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
        let myString1 = NSMutableAttributedString(string: " "+inputtxt)
        myString.append(myString1)
        categoryLabel.attributedText = myString
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
