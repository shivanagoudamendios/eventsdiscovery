//
//  AddtocontactsViewController.swift
//  webMOBI
//
//  Created by shanmukh dm on 23/02/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit
import SDWebImage

protocol refreshviewcontroller {
    func refreshview()
}

class AddtocontactsViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, refreshviewcontroller{

   
    @IBOutlet weak var scanBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var businessScanAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var businessCardImage: UIImageView!
    @IBOutlet weak var businessPro: UITextView!
    @IBOutlet var businessScanArea: UIView!
    @IBOutlet weak var scanBusinessCard: NSLayoutConstraint!
    @IBOutlet weak var businessCardHeight: NSLayoutConstraint!
    @IBOutlet weak var businessTableView: UITableView!
    var business : [businessCard] = []
    let defaults = UserDefaults.standard
    let animals : [String] = ["Dogs","Cats","Mice"]
//    var storyboard = UIStoryboard()
//    switch UIDevice.current.userInterfaceIdiom {
//    case .phone:
//    storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
//    case .pad:
//    storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
//    default:
//    print("Device not detectable")
//    }
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var scanView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startscan(_:)))
        tapGesture.delegate = self
        scanView.addGestureRecognizer(tapGesture)
        
        //Table View properties
     
        businessTableView.delegate      =   self
        businessTableView.dataSource    =   self
//        businessTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let nib = UINib.init(nibName: "BusinessCardTableViewCell", bundle: nil)
        businessTableView.register(nib, forCellReuseIdentifier: "businesscardcell")
        self.scanBusinessCard.constant = 0
        self.businessCardHeight.constant = 60
        self.businessScanAreaHeight.constant = 60
        self.businessPro.isHidden = true
        self.businessCardImage.isHidden = true
        self.view.addSubview(self.businessTableView)
        businessTableView.tableFooterView = UIView()
        checkforloginaccess()
//        let userdata = UserDefaults.standard.value(forKey: "userlogindata")
//        if userdata == nil{
//            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default){
//                UIAlertAction in
//                self.tabBarController?.selectedIndex = 0
//            })
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            readingBusinessInfo()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkforloginaccess()
//        let userdata = UserDefaults.standard.value(forKey: "userlogindata")
//        if userdata == nil{
//            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default){
//                UIAlertAction in
//                self.tabBarController?.selectedIndex = 0
//            })
//            self.present(alert, animated: true, completion: nil)
//        }
      
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func presentloginscreen() {
        
        var storyboard = UIStoryboard()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else {
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        }
        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
        //let navigationController = UINavigationController(rootViewController: vc)
        
      self.present(vc, animated: true, completion: nil)
    //self.navigationController?.pushViewController(navigationController, animated: true)
    }
    
    func checkforloginaccess() {
        if UserDefaults.standard.value(forKey: "userlogindata") == nil{
           self.tabBarController?.selectedIndex = 0
            presentloginscreen()
            
    //    self.present(self, animated: true, completion: nil)
//            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
//
////            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
////                UIAlertAction in
////                self.tabBarController?.selectedIndex = 0
////                //self.checkforloginaccess()
////            })
//
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//                UIAlertAction in
//
//                self.presentloginscreen()
//                self.tabBarController?.selectedIndex = 0
//            })
//
//            self.present(alert, animated: true, completion: nil)
       }else{
             readingBusinessInfo()

            print("Already LoggedIn")
        }
        
    }
    func startscan(_ sender : UITapGestureRecognizer)
    {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        let newViewController = SaveContactViewController(nibName: "SaveContactViewController", bundle: nil)
        newViewController.cardImage = image
        newViewController.delegate = self
        self.navigationController?.pushViewController(newViewController, animated: true)
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
//        if(business.count == 0)
//        {
//            self.scanBtnHeight.constant = self.view.frame.height/2 - 111
//        }
//        else
//        {
//            self.scanBtnHeight.constant = 10
//        }
        return business.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "businesscardcell") as! BusinessCardTableViewCell
        cell.biuserdesc.text = String(business[indexPath.row].designation)
        cell.biuserpro.layer.cornerRadius = cell.biuserpro.frame.size.width / 2
        cell.biuserpro.clipsToBounds = true
        cell.biuserpro.sd_setImage(with: URL(string : business[indexPath.row].card_image_url), placeholderImage: UIImage(named : "profileunselected"))
        cell.biusername.text = String(business[indexPath.row].contact_first_name)
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(animals[indexPath.row])
        var storyboard = UIStoryboard()
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else {
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        }
        let nextVC = storyboard.instantiateViewController(withIdentifier: "BusinessCardProfileViewController") as! BusinessCardProfileViewController
        nextVC.businessDetailView = business[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func refreshview() {
        self.view.addLoader()
        readingBusinessInfo()
    }
    
    func readingBusinessInfo(){
       // let appid = self.defaults.string(forKey: "selectedappid")!
                let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
                let userId = data1["userId"]! as! String
//         var userid = UserDefaults.standard.string(forKey: )!
//        userid = defaults.string(forKey: "EvntUserId")!
        let half_url = ServerApis.getContacts + userId.description
        
        print(half_url)
        let request = NSMutableURLRequest(url: NSURL(string: half_url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                        let responseString = json["responseString"]!
                        let questionarray1 =  json["contacts"] as! [NSDictionary]
                        
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                //                                    self.rateThisIcon.isHidden = false
                                //                                    self.rateThisIcon.rating = responseString as! Float
                                // UserDefaults.standard.set(data, forKey: json)
                                for item in questionarray1
                                {
                                    var question: businessCard = businessCard()
                                   
                                    question.contact_first_name = item["contact_first_name"] as! String
                                    question.contact_last_name = item["contact_last_name"] as! String
                                    question.designation = item["designation"] as! String
                                    question.card_image_url = item["card_image_url"] as! String
                                    question.address = item["address"] as! String
                                    question.card_type = item["card_type"] as! String
                                    question.company = item["company"] as! String
                                    question.contact_email = item["contact_email"] as! String
                                    question.contact_email_1 = item["contact_email_1"] as! String
                                    question.contact_phone = item["contact_phone"] as! String
                                    question.contact_phone_1 = item["contact_phone_1"] as! String
                                    question.contact_id = item["contact_id"] as! Int
                                    question.website = item["website"] as! String
                                    question.website_1 = item["website_1"] as! String
                                    question.userid = item["userid"] as! String
                                    question.fax = item["fax"] as! String
                                    question.contact_info = item["contact_info"] as! String
                                   
                                    self.business.append(question)
                                    //self.businessTableView.constant = CGFloat(self.quest.count * 40)
                                    self.businessTableView.reloadData()
                                    //                                    self.viewDidLayoutSubviews()
                                    self.view.removeLoader()
                                }
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "Request Failed", message: "Questions could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
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
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "Request Failed", message: "Questions could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
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
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: "Questions could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
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
