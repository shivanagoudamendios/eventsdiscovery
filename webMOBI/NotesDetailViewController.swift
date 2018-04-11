//
//  NotesDetailViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/19/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MBProgressHUD

class NotesDetailViewController: UIViewController {
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var NotesEditField: UITextView!
    var notestitle: String? = ""
    var notesText: String? = ""
    var notesID: String = ""
    var notesType = ""
    var hud = MBProgressHUD()
    let defaults = UserDefaults.standard
    var lastUpdated : Int64!
    var didupload : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = notestitle
        NotesEditField.text = notesText
        NotesEditField.layer.borderWidth = 1.0
        NotesEditField.layer.borderColor = UIColor.gray.cgColor
        NotesEditField.layer.cornerRadius = 5
        NotesEditField.clipsToBounds = true
        
        saveBtn.setBackgroundImage(UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-save")!, textColor: UIColor.black, size: CGSize(width: 25, height: 25)), for: .normal)
        closeBtn.setBackgroundImage(UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-close")!, textColor: UIColor.black, size: CGSize(width: 25, height: 25)), for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        NotesEditField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        lastUpdated = getCurrentMillis()
        postnotes()
        savenotes()
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func savenotes() {
        NotesEditField.resignFirstResponder()
        let appid = self.defaults.string(forKey: "selectedappid")
        let idToStore = "\(appid!)\(notesID)"
        switch notesType {
        case "agenda":
            if CoreDataManager.checkforAgendaID(id: idToStore){
                CoreDataManager.UpdateNotesfromAgendaID(agendaID: idToStore, agendaNotes: NotesEditField.text, agendaDidAdd: true, lastUpdated: lastUpdated)
            }
        case "sponsor":
            if CoreDataManager.checkforSponsorsID(id: idToStore){
                CoreDataManager.UpdateNotesfromSponsorsID(sponsorsID: idToStore, sponsorsNotes: NotesEditField.text, sponsorsDidAdd: true, lastUpdated: lastUpdated)
            }
            
        case "exhibitor":
            if CoreDataManager.checkforExhibitorsID(id: idToStore){
                CoreDataManager.UpdateNotesfromExhibitorsID(exhibitorsID: idToStore, exhibitorsNotes: NotesEditField.text, exhibitorsDidAdd: true, lastUpdated: lastUpdated)
            }
        default:
            print("Deault print")
        }
    }
    
    func updateCoreDataBool() {
        let appid = self.defaults.string(forKey: "selectedappid")
        let idToStore = "\(appid!)\(notesID)"
        switch notesType {
        case "agenda":
            CoreDataManager.UpdateBoolforAgendaID(agendaID: idToStore, agendaDidAdd: false)
        case "sponsor":
            CoreDataManager.UpdateBoolforSponsorsID(sponsorsID: idToStore, notesDidAdd: false)
        case "exhibitor":
            CoreDataManager.UpdateBoolforExhibitorsID(exhibitorsID: idToStore, exhibitorsDidAdd: false)
        default:
            print("Deault print")
        }
        
    }
    
    func postnotes() {
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Saving..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let appid = self.defaults.string(forKey: "selectedappid")
        let userid = defaults.string(forKey: "EvntUserId")!
        self.hud.hide(true, afterDelay: 0)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.labelText = "Saving..."
        hud.minSize = CGSize(width: 150, height: 100)
        
        let request = NSMutableURLRequest(url: NSURL(string: ServerApis.NotesUrl)! as URL)
        request.httpMethod = "POST"
        let params = ["userid": userid as AnyObject,
                      "appid": appid as AnyObject,
                      "type": notesType as AnyObject,
                      "type_id": notesID as AnyObject,
                      "type_name": notestitle as AnyObject,
                      "last_updated": lastUpdated as AnyObject,
                      "notes": NotesEditField.text as AnyObject,
                      "action": "update" as AnyObject
            ] as Dictionary<String, AnyObject>
        print(params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
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
                                self.hud.hide(true, afterDelay: 0.5)
                                self.savenotes()
                                self.updateCoreDataBool()
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
                                self.hud.hide(true, afterDelay: 0.5)
                                if UserDefaults.standard.bool(forKey: "didsync") == false{
                                    UserDefaults.standard.set(true, forKey: "didsync")
                                }
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
                            self.hud.hide(true, afterDelay: 0.5)
                            if UserDefaults.standard.bool(forKey: "didsync") == false{
                                UserDefaults.standard.set(true, forKey: "didsync")
                            }
                            let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.dismiss(animated: true, completion: nil)
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                    self.hud.hide(true, afterDelay: 0.5)
                }
            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.hud.hide(true, afterDelay: 0.5)
                        if UserDefaults.standard.bool(forKey: "didsync") == false{
                            UserDefaults.standard.set(true, forKey: "didsync")
                        }
                        let alert = UIAlertController(title: "Request Failed", message: "Notes not saved!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.dismiss(animated: true, completion: nil)
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
                self.hud.hide(true, afterDelay: 0.5)
            }
        })
        task.resume()
    }

}
