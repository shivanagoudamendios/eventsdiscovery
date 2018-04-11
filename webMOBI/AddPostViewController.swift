//
//  AddPostViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/2/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit
import Photos
import OpalImagePicker

class AddPostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, OpalImagePickerControllerDelegate {

    @IBOutlet weak var selectedImagesView: UIView!
    @IBOutlet weak var DescritionTextView: UITextView!
    @IBOutlet weak var NavBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postDescTextField: UITextView!
    @IBOutlet weak var postImagesButton: UIButton!
    @IBOutlet weak var postCameraButton: UIButton!
    @IBOutlet weak var DescriptrionViewBottomHeight: NSLayoutConstraint!
    @IBOutlet weak var DescriptionView: UIView!
    
    let defaults = UserDefaults.standard
    var NavBarViewOriginY : CGFloat = 0
    let picker = UIImagePickerController()
    let imagePicker = OpalImagePickerController()
    var imageData : [String] = []
    var postImages : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.isUserInteractionEnabled = false
        imagePicker.imagePickerDelegate = self
        picker.delegate = self
        selectedImagesView.clipsToBounds = true
        postDescTextField.delegate = self
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.NavBarView.backgroundColor = UIColor.init(hex: themeclr)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardDidShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardDidHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func postAction(_ sender: UIButton) {
        self.view.endEditing(true)
        postFeed(post_name: "", post_content: DescritionTextView.text!, Images: postImages)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImages(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController( title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present( alertVC, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0{
            postButton.setTitleColor(UIColor.white, for: .normal)
            postButton.isUserInteractionEnabled = true
        }else{
            postButton.setTitleColor(UIColor.gray, for: .normal)
            postButton.isUserInteractionEnabled = false
        }
        print(textView.text!)
        DescritionTextView.text = textView.text
    }
    
    func handleKeyboardDidShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.DescriptrionViewBottomHeight.constant = keyboardFrame.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func handleKeyboardDidHideNotification(notification: NSNotification) {
        self.DescriptrionViewBottomHeight.constant = 0
        self.view.layoutIfNeeded()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageData.removeAll()
        postImages.removeAll()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let myImageView = UIImageView()
        myImageView.frame = selectedImagesView.bounds
        myImageView.contentMode = .scaleAspectFill
        myImageView.image = chosenImage
        myImageView.clipsToBounds = true
        selectedImagesView.addSubview(myImageView)
        imageData.append(chosenImage.toBase64())
        postImages.append(chosenImage)
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Multiple selection
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        print("imagePickerDidCancel")
    }
    
    func addImagesToView(images: [UIImage]) {
        if images.count == 1{
            let myImageView = UIImageView()
            myImageView.frame = selectedImagesView.bounds
            myImageView.tag = 1
            myImageView.contentMode = .scaleAspectFill
            myImageView.image = images[0]
            myImageView.clipsToBounds = true
            selectedImagesView.addSubview(myImageView)
        }else if images.count == 2{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height)  //selectedImagesView.bounds
            myImageView.contentMode = .scaleAspectFill
            myImageView.image = images[0]
            myImageView.clipsToBounds = true
            selectedImagesView.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: selectedImagesView.frame.midX, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.image = images[1]
            myImageView1.clipsToBounds = true
            selectedImagesView.addSubview(myImageView1)
            
        }else if images.count == 3{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView.contentMode = .scaleAspectFill
            myImageView.image = images[0]
            myImageView.clipsToBounds = true
            selectedImagesView.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: selectedImagesView.frame.midX, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.image = images[1]
            myImageView1.clipsToBounds = true
            selectedImagesView.addSubview(myImageView1)
            
            let myImageView2 = UIImageView()
            myImageView2.tag = 1
            myImageView2.frame = CGRect(x: 0, y: selectedImagesView.frame.height/2, width: selectedImagesView.frame.width, height: selectedImagesView.frame.height/2)
            myImageView2.contentMode = .scaleAspectFill
            myImageView2.image = images[2]
            myImageView2.clipsToBounds = true
            selectedImagesView.addSubview(myImageView2)
        }else if images.count == 4{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView.contentMode = .scaleAspectFill
            myImageView.image = images[0]
            myImageView.clipsToBounds = true
            selectedImagesView.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: selectedImagesView.frame.midX, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.image = images[1]
            myImageView1.clipsToBounds = true
            selectedImagesView.addSubview(myImageView1)
            
            let myImageView2 = UIImageView()
            myImageView2.tag = 1
            myImageView2.frame = CGRect(x: 0, y: selectedImagesView.frame.height/2, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView2.contentMode = .scaleAspectFill
            myImageView2.image = images[2]
            myImageView2.clipsToBounds = true
            selectedImagesView.addSubview(myImageView2)
            
            let myImageView3 = UIImageView()
            myImageView3.tag = 1
            myImageView3.frame = CGRect(x: selectedImagesView.frame.midX, y: selectedImagesView.frame.height/2, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView3.contentMode = .scaleAspectFill
            myImageView3.image = images[3]
            myImageView3.clipsToBounds = true
            selectedImagesView.addSubview(myImageView3)
        }else if images.count > 4{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView.contentMode = .scaleAspectFill
            myImageView.image = images[0]
            myImageView.clipsToBounds = true
            selectedImagesView.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: selectedImagesView.frame.midX, y: 0, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.image = images[1]
            myImageView1.clipsToBounds = true
            selectedImagesView.addSubview(myImageView1)
            
            let myImageView2 = UIImageView()
            myImageView2.tag = 1
            myImageView2.frame = CGRect(x: 0, y: selectedImagesView.frame.height/2, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView2.contentMode = .scaleAspectFill
            myImageView2.image = images[2]
            myImageView2.clipsToBounds = true
            selectedImagesView.addSubview(myImageView2)
            
            let myImageView3 = UIImageView()
            myImageView3.tag = 1
            myImageView3.frame = CGRect(x: selectedImagesView.frame.midX, y: selectedImagesView.frame.height/2, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            myImageView3.contentMode = .scaleAspectFill
            myImageView3.image = images[3]
            myImageView3.clipsToBounds = true
            selectedImagesView.addSubview(myImageView3)
            
            let myView = UIView()
            myView.tag = 1
            myView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            myView.frame = CGRect(x: selectedImagesView.frame.midX, y: selectedImagesView.frame.height/2, width: selectedImagesView.frame.width/2, height: selectedImagesView.frame.height/2)
            let mylabel = UILabel()
            mylabel.frame = myView.bounds
            mylabel.textAlignment = .center
            mylabel.contentMode = .center
            mylabel.textColor = UIColor.white
            mylabel.text = "+\(images.count - 4)"
            mylabel.font = UIFont.systemFont(ofSize: 30)
            myView.addSubview(mylabel)
            myView.clipsToBounds = true
            selectedImagesView.addSubview(myView)
        }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {
        print("count: ", images.count)
        for view in selectedImagesView.subviews{
            if view.tag == 1{
                view.removeFromSuperview()
            }
        }
        imageData.removeAll()
        postImages.removeAll()
        for image in images{
            imageData.append(image.toBase64())
            postImages.append(image)
        }
        addImagesToView(images: images)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func serializeJson(object : Any) -> String
    {
        if let json = try? JSONSerialization.data(withJSONObject: object , options: []) {
            if let content = String(data: json, encoding: String.Encoding.utf8) {
                // here `content` is the JSON dictionary containing the String
                return content
            }
        }else
        {
            return [].description
        }
        return [].description
    }

    
    func postFeed(post_name: String, post_content: String, Images: [UIImage]) {
        
        let appid = self.defaults.string(forKey: "selectedappid")
        let userid = defaults.string(forKey: "EvntUserId")!
        
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.postFeeds)! as URL)
        request.httpMethod = "POST"
        let post_req = ["appid": appid as AnyObject,
                      "userid": userid as AnyObject,
                      "post_name": post_name as AnyObject,
                      "post_content": post_content as AnyObject,
                      "create_time": Date().millisecondsSince1970 as AnyObject
            ] as Dictionary<String, AnyObject>
        print(post_req)
        var attachment : [Dictionary<String, AnyObject>] = []
        if selectedImagesView.subviews.count > 1{
            for imagecnt in 0..<postImages.count{
                let data = ["res_name": "TempName.png" as AnyObject,
                            "res_type": "image/png" as AnyObject,
                            "res_description": "testing Desc" as AnyObject,
                            "res_blob": imageData[imagecnt] as AnyObject,
                            "res_width": postImages[imagecnt].size.width as AnyObject,
                            "res_height": postImages[imagecnt].size.height as AnyObject
                    ] as Dictionary<String, AnyObject>
                print(data)
                attachment.append(data)
            }
        }
        let params = ["post_req": post_req as AnyObject,
                      "attachments": attachment as AnyObject
            ] as Dictionary<String, AnyObject>
        print("attachment.description", attachment.description)
        print("serializeJson(object: attachment)", serializeJson(object: attachment))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error!)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Request Failed", message: (error! as NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
