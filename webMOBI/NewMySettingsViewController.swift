//
//  NewMySettingsViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/27/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import SDWebImage

class NewMySettingsViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profilename: UITextView!
    @IBOutlet weak var profileJobPostion: UITextView!
    @IBOutlet weak var linkedInSync: UIView!
    @IBOutlet weak var linkedInLogo: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var jobPosition: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var editProfilePic: UILabel!
    @IBOutlet weak var scrollviewinsetsheight: NSLayoutConstraint!
    @IBOutlet weak var logoutview : UIView!
    @IBOutlet weak var updateview : UIView!
    @IBOutlet weak var logoutlabel: UILabel!
    @IBOutlet weak var updatelabel: UILabel!
    @IBOutlet weak var blogurl: UITextField!
    @IBOutlet weak var descriptiontextview: UITextView!
    let defaults = UserDefaults.standard
    var profilepicUrl = ""
    var profilepicUrlfromLinkedIn = ""
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.title = "Settings"
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        let logout = String.fontAwesomeIcon(code: "fa-power-off")
        let pencil = String.fontAwesomeIcon(code: "fa-pencil")
        let check = String.fontAwesomeIcon(code: "fa-check-circle")
        let linkedinLogo = String.fontAwesomeIcon(code: "fa-linkedin")
        linkedInLogo.font = UIFont.fontAwesome(ofSize: 15)
        editProfilePic.font = UIFont.fontAwesome(ofSize: 15)
        updatelabel.font = UIFont.fontAwesome(ofSize: 22)
        logoutlabel.font = UIFont.fontAwesome(ofSize: 22)
        linkedInLogo.text = linkedinLogo!
        editProfilePic.text = pencil!
        updatelabel.text = check!
        logoutlabel.text = logout!
        updatelabel.textColor = UIColor.white
        logoutlabel.textColor = UIColor.white
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        mobileNumber.delegate = self
        jobPosition.delegate = self
        company.delegate = self
        website.delegate = self
        blogurl.delegate = self
        descriptiontextview.delegate = self
        logoutview.backgroundColor = UIColor.white
        updateview.backgroundColor = UIColor.white
        setShadowToview(view: logoutview)
        setShadowToview(view: updateview)
        self.navigationController?.navigationBar.isTranslucent = true
        linkedInSync.backgroundColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        self.editProfilePic.textColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        logoutlabel.textColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        updatelabel.textColor = UIColor(red: 30/255, green: 112/255, blue: 145/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.profileImage.layer.masksToBounds = true
        self.editProfilePic.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = 35
        self.editProfilePic.layer.cornerRadius = 15
        self.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        self.profileImage.layer.borderWidth = 0.5
        self.editProfilePic.layer.borderColor = UIColor.lightGray.cgColor
        self.editProfilePic.layer.borderWidth = 1
        self.editProfilePic.textAlignment = .center
        self.editProfilePic.backgroundColor = UIColor.white
        
        self.linkedInLogo.textColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        scrollviewinsetsheight.constant = (self.navigationController?.navigationBar.frame.height)! + 20
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(self.keyboardOnScreen(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        center.addObserver(self, selector: #selector(self.keyboardOffScreen(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        if defaults.bool(forKey: "infoprivacy1"){
            changePassword.isHidden = true
        }else{
            let didloginfromsocial : Bool = UserDefaults.standard.bool(forKey: "didloginfromsocial")
            if didloginfromsocial{
                changePassword.isHidden = true
            }else{
                changePassword.isHidden = false
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.logoutAction))
        tap.delegate = self
        logoutview.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.updateprofile))
        tap1.delegate = self
        updateview.addGestureRecognizer(tap1)
        
        firstName.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        lastName.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        jobPosition.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    func textFieldDidChange(textField : UITextField){
        if (textField == firstName) || (textField ==  lastName){
            profilename.text = firstName.text! + " " + lastName.text!
            profilename.font = UIFont.boldSystemFont(ofSize: 19.0)
        }else if textField == jobPosition{
            profileJobPostion.text = jobPosition.text!
            profileJobPostion.font = UIFont.systemFont(ofSize: 19.0)
        }
    }
    
    func setShadowToview(view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 0.5
        
    }
    
    func removeLocalFiles(){
        let fileManager = FileManager.default
        let directory = FileManager.SearchPathDirectory.documentDirectory
        let filepath = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)[0]
        let subDirectory = "SavingFiles"
        let folder = filepath + "/\(subDirectory)"
        do {
            try fileManager.removeItem(atPath: folder)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadMyEvents"), object: nil)
    }
    
    
    func logoutMethod()  {
        
        self.defaults.removeObject(forKey: "userlogindata")
        self.removeLocalFiles()
        self.defaults.set(self.defaults.bool(forKey: "infoprivacy1"), forKey: "infoprivacy")
        self.defaults.setValue("", forKey: "EvntUserId")
        self.defaults.set(false, forKey: "login")
        self.defaults.setValue("", forKey: "email")
        self.defaults.setValue("", forKey: "Useremail")
        self.defaults.setValue("", forKey: "lastname")
        self.defaults.setValue("", forKey: "name")
        self.defaults.setValue("", forKey: "companyName")
        self.defaults.setValue("", forKey: "designation")
        self.defaults.setValue("", forKey: "mobile")
        self.defaults.setValue("", forKey: "profilepic")
        self.defaults.setValue("", forKey: "role")
        self.defaults.setValue("", forKey: "website")
        self.defaults.set(true, forKey: "logoutflag")
        self.defaults.set(false, forKey: "didsync")
        self.defaults.setValue([Int](), forKey: "exhibitor_favorites")
        self.defaults.setValue([Int](), forKey: "schedules")
        self.defaults.setValue([Int](), forKey: "sponsor_favorites")
        self.defaults.setValue("", forKey: "token")
        CoreDataManager.cleanAgendaCoreData()
        CoreDataManager.cleanSponsorsCoreData()
        CoreDataManager.cleanExhibitorsCoreData()
        CoreDataManager.cleanAgendaRatingsCoreData()
        CoreDataManager.cleanSpeakersRatingsCoreData()
        CoreDataManager.cleanDownloadedEventCoreData()
        CoreDataManager.cleanLoginDetailCoreData()
        CoreDataManager.cleanExhibitorFavoritesCoreData()
        CoreDataManager.cleanScheduleFavoritesCoreData()
        CoreDataManager.cleanSponsorsFavoritesCoreData()
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
        
    }
    var currentuserId = ""
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "userlogindata") != nil{
            let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            if(currentuserId != data1["userId"]! as! String)
            {
                getProfileDetails()
            }
        }
        
        firstName.setBottomBorder()
        lastName.setBottomBorder()
        email.setBottomBorder()
        mobileNumber.setBottomBorder()
        jobPosition.setBottomBorder()
        company.setBottomBorder()
        website.setBottomBorder()
        blogurl.setBottomBorder()
        setShadowToview(view: descriptiontextview)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.UpdateProfilePic))
        editProfilePic.isUserInteractionEnabled = true
        editProfilePic.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.UpdateFromLinkedIn))
        linkedInSync.isUserInteractionEnabled = true
        linkedInSync.addGestureRecognizer(tap1)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let nextbutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donepressed))
        
        toolbar.setItems([flexSpace,nextbutton], animated: true)
        descriptiontextview.inputAccessoryView = toolbar
        
    }
    
    func donepressed() {
        descriptiontextview.resignFirstResponder()
    }
    
    func logoutAction()
    {
//        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
//            DispatchQueue.main.async(execute: {() -> Void in
//        HomeTabViewController().checkforloginaccess()
//            })
//        })
        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        let token = data1["token"]! as! String
        self.view.addLoader()
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.Logout)! as URL)
        request.httpMethod = "POST"
        let params = ["deviceType": "ios" as AnyObject,
                      "deviceId": defaults.string(forKey: "devicetoken") as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        request.setValue(token, forHTTPHeaderField: "Token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                        let responseString = json["responseString"] as! String
                        print(responseString)
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
                                self.logoutMethod()
                                let alert = UIAlertController(title: "SUCCESS", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutNotification"), object: nil)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "Request Failed", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    print("json")
                    self.view.removeLoader()
                }
            }else{
                print("json")
                self.view.removeLoader()
            }
        })
        task.resume()
        
    }
    
    func UpdateProfilePic() {
        print("UpdateProfilePic")
        DispatchQueue.main.async { () -> Void in
            
            let alertCtrl = UIAlertController(title: "Upload Photo", message: "Select upload type", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            
            let GalleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let ImagePicker = UIImagePickerController()
                ImagePicker.delegate = self
                ImagePicker.allowsEditing = true
                ImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(ImagePicker, animated: true, completion: nil)
                
            }
            let CameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let ImagePicker = UIImagePickerController()
                ImagePicker.delegate = self
                ImagePicker.allowsEditing = true
                ImagePicker.sourceType = UIImagePickerControllerSourceType.camera
                
                self.present(ImagePicker, animated: true, completion: nil)
            }
            
            let removeImgAction = UIAlertAction(title: "Remove Current Photo", style: UIAlertActionStyle.destructive) {
                UIAlertAction in
                self.uploadimgtoServer(image_data: "")
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                
            }
            
            
            
            alertCtrl.addAction(GalleryAction)
            alertCtrl.addAction(CameraAction)
            alertCtrl.addAction(cancelAction)
            alertCtrl.addAction(removeImgAction)
            
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
                
                if let popoverController = alertCtrl.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                self.present(alertCtrl, animated: true, completion: nil)
            }else{
                self.present(alertCtrl, animated: true, completion: nil)
            }
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        var selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        selectedImage = cropImageToSquare(image: selectedImage)!
        let Imgview = self.profileImage
        DispatchQueue.main.async { () -> Void in
            Imgview?.image = selectedImage
            
            if(Imgview?.image != nil)
            {
                let imgstr = (selectedImage.toBase64())
                self.uploadimgtoServer(image_data: imgstr)
                
            }
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
    
    func uploadimgtoServer(image_data: String)
    {
        self.view.addLoader()
        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        let token = data1["token"]! as! String
        let appurl = self.defaults.string(forKey: "selectedappurl")
        let userId = data1["userId"]! as! String
        var request = URLRequest(url: URL(string: ServerApis.UpdateProfilePic)!)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Token")
        
        let params = ["image":image_data as AnyObject,
                      "userid":userId as AnyObject,
                      "appurl":appurl as AnyObject,
                      "user_type":"eventuser" as AnyObject] as Dictionary<String, AnyObject>
        print(params)
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                self.view.removeLoader()
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        //                        self.profileImage.image = UIImage(named:"EmptyUser.png")
                        let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 201 , httpStatus.statusCode != 200{           // check for http errors
                print("statusCode should be 201, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                self.view.removeLoader()
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        //                        self.profileImage.image = UIImage(named:"EmptyUser.png")
                        let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }else{
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        //                        print("Synchronous\(jsonResult)")
                        let responseFlg = jsonResult["response"] as? Bool
                        let jsonResult1 = jsonResult["responseString"] as AnyObject
                        if(responseFlg)!
                        {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.view.removeLoader()
                                    guard let imgurl = jsonResult1 as? String else{
                                        return
                                    }
                                    ImageLoadingWithCache().getImage(url: imgurl , imageView:  self.profileImage, defaultImage: "EmptyUser.png")
                                    
                                })
                            })
                        }else
                        {
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.view.removeLoader()
                                    let alert = UIAlertController(title: "Request Failed", message: jsonResult1 as? String, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                })
                            })
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "Request Failed", message: "Please Check The connection Try Again", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
            }
        }
        task.resume()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func UpdateFromLinkedIn() {
        print("UpdateFromLinkedIn")
        syncFromLinkedIn()
    }
    
    func syncFromLinkedIn() {
        
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            print("success called!")
            let session = LISDKSessionManager.sharedInstance().session
            print(session!)
            let url = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,email-address,location:(name),industry,public-profile-url,picture-url,primary-twitter-account,network,skills,summary,phone-numbers,date-of-birth,main-address,positions:(title,company:(name)),educations:(school-name,field-of-study,start-date,end-date,degree,activities))"
            
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) -> Void in
                    
                    let str = response?.data
                    do {
                        let jsonResult: NSDictionary =  try JSONSerialization.jsonObject(with: str!.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        print(jsonResult)
                        print(jsonResult.value(forKey: "firstName")!)
                        print(jsonResult.value(forKey: "lastName")!)
                        print(jsonResult.value(forKey: "formattedName")!)
                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                let  posobj = (jsonResult.value(forKey: "positions")! as AnyObject).value(forKey: "values") as? [AnyObject]
                                
                                if((posobj?.count)! > 0)
                                {
                                    let companyname1 = posobj?[0]["company"] as? [String: AnyObject]
                                    let companynme = companyname1?["name"] as! String
                                    let job = posobj![0]["title"] as? String
                                    self.jobPosition.text = job
                                    self.company.text = companynme
                                    self.profileJobPostion.text = companynme
                                }
                                
                                self.firstName.text = jsonResult.value(forKey: "firstName") as? String
                                self.lastName.text = jsonResult.value(forKey: "lastName") as? String
                                self.profilename.text = (jsonResult.value(forKey: "firstName") as? String)! + " " + (jsonResult.value(forKey: "lastName") as? String)!
                                self.profilename.font = UIFont.boldSystemFont(ofSize: 19.0)
                                self.profileJobPostion.font = UIFont.systemFont(ofSize: 19.0)
                                let imgurl = jsonResult.value(forKey: "pictureUrl") as? String
                                
                                if(imgurl?.isEmpty == false)
                                {
                                    self.defaults.setValue(imgurl, forKey: "profilepic")
                                    let profilpiculr = self.defaults.value(forKey: "profilepic")
                                    print(profilpiculr!)
                                    self.profilepicUrlfromLinkedIn = profilpiculr as! String
                                    ImageLoadingWithCache().getImage(url: profilpiculr as! String , imageView:  self.profileImage, defaultImage: "EmptyUser.png")
                                }
                                
                            })
                        })
                        
                    }catch
                    {
                        
                    }
                    
                    
                }, error: { (error) -> Void in
                    DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            
                            UIAlertView(title: "Error",message: "LinkedIn Not Synced",delegate: nil,cancelButtonTitle: "OK").show()
                            
                        })
                    })
                    
                })
            }
            
        }) { (error) -> Void in
            print("Error: \(error)")
        }
        
        
    }
    
    func keyboardOnScreen(_ notification: Notification){
        
        let info: NSDictionary  = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as AnyObject).cgRectValue.size
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        
    }
    
    func keyboardOffScreen(_ notification: Notification){
        
        let contentInsets:UIEdgeInsets = UIEdgeInsets.zero
        scrollviewinsetsheight.constant = (self.navigationController?.navigationBar.frame.height)! + 20
        scrollview.contentInset = contentInsets
        scrollview.scrollIndicatorInsets = contentInsets
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 7{
            descriptiontextview.becomeFirstResponder()
        }else{
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return false
    }
    
    func getProfileDetails() {
        self.view.addLoader()
        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        let userId = data1["userId"]! as! String
        
        let profileurl = (ServerApis.GetProfileUrl) + userId
        let request = NSMutableURLRequest(url: NSURL(string: profileurl)! as URL)
        let token = data1["token"]! as! String
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Token")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                        })
                    })
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: Any]
                    print(json)
                    if ((json["response"] as! Bool) == true){
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                let responseString = json["Profile"] as! NSArray
                                let detail = responseString[0] as! [String: Any]
                                print(detail)
                                let firstName = detail["first_name"] as! String
                                let lastName = detail["last_name"] as! String
                                self.firstName.text = firstName
                                self.lastName.text = lastName
                                self.email.text = (detail["email"] as! String?)!
                                self.mobileNumber.text = (detail["mobile"] as! String?)!
                                self.jobPosition.text = (detail["designation"] as! String?)!
                                self.company.text = (detail["company"] as! String?)!
                                self.website.text = (detail["website"] as! String?)!
                                self.profilename.text = firstName + " " + lastName
                                self.profileJobPostion.text = (detail["designation"] as! String?)!
                                self.profilepicUrl = (detail["profile_pic"] as! String?)!
                                if (self.profilepicUrl.characters.count) > 0{
                                    ImageLoadingWithCache().getImage(url: self.profilepicUrl, imageView:  self.profileImage, defaultImage: "EmptyUser.png")
                                }else{
                                    self.profileImage.image = UIImage(named: "EmptyUser.png")
                                }
                                self.profilename.font = UIFont.boldSystemFont(ofSize: 19.0)
                                self.profileJobPostion.font = UIFont.systemFont(ofSize: 19.0)
                                self.blogurl.text = detail["user_blog"] as? String
                                self.descriptiontextview.text = detail["description"] as! String
                                //                                self.currentuserId = self.defaults.string(forKey: "EvntUserId")!
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "Request Failed", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    print("json")
                    self.view.removeLoader()
                }
            }else{
                print("json")
                self.view.removeLoader()
            }
        })
        task.resume()
        
    }
    
    func updateprofile()  {
        if (firstName.text?.characters.count)! > 0 && (lastName.text?.characters.count)! > 0 && (mobileNumber.text?.characters.count)! > 0 && (jobPosition.text?.characters.count)! > 0 && (company.text?.characters.count)! > 0{
            var profilepicurlfromLinkedIn = ""
            if self.profilepicUrlfromLinkedIn.characters.count > 0{
                profilepicurlfromLinkedIn = self.profilepicUrlfromLinkedIn
            }
            self.view.addLoader()
            let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
            let userId = data1["userId"]! as! String
            let request = NSMutableURLRequest(url: NSURL(string: ServerApis.ProfileupdateUrl)! as URL)
            request.httpMethod = "POST"
            let params = ["userid": userId as AnyObject,
                          "first_name": (firstName.text!) as AnyObject,
                          "last_name": (lastName.text!) as AnyObject,
                          "phone": (mobileNumber.text!) as AnyObject,
                          "designation": (jobPosition.text!) as AnyObject,
                          "company": (company.text!) as AnyObject,
                          "profile_pic_url": profilepicurlfromLinkedIn as AnyObject,
                          "website": (website.text!) as AnyObject,
                          "user_blog": (blogurl.text!) as AnyObject,
                          "description": (descriptiontextview.text!) as AnyObject
                ] as Dictionary<String, AnyObject>
            print(params)
            let token = data1["token"]! as! String
            request.setValue(token, forHTTPHeaderField: "Token")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
                            let responseString = json["responseString"] as! String
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.view.removeLoader()
                                    var data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
                                    data1["username"]! = (self.firstName.text!) + " " + (self.lastName.text!)
                                    UserDefaults.standard.setValue(data1, forKeyPath: "userlogindata")
                                    let alert = UIAlertController(title: "SUCCESS", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                    })
                                    self.present(alert, animated: true, completion: nil)
                                })
                            })
                        }else{
                            let responseString = json["responseString"] as! String
                            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                                DispatchQueue.main.async(execute: {() -> Void in
                                    self.view.removeLoader()
                                    let alert = UIAlertController(title: "Request Failed", message: responseString, preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                        UIAlertAction in
                                    })
                                    self.present(alert, animated: true, completion: nil)
                                })
                            })
                        }
                    }catch {
                        print("json")
                        self.view.removeLoader()
                    }
                }else{
                    print("json")
                    self.view.removeLoader()
                }
            })
            task.resume()
        }else{
            let alert = UIAlertController(title: "Request Failed", message: "Profile is Incomplete", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
