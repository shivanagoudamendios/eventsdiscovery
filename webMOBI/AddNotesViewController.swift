//
//  AddNotesViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/16/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddNotesViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var notesbackground: UIView!
    @IBOutlet weak var notestextview: UITextView!
    @IBOutlet weak var cancelbutton: UIButton!
    @IBOutlet weak var savebutton: UIButton!
    var NoteID : Int64 = 0
    var NoteType = ""
    var NoteName = ""
    var hud = MBProgressHUD()
    let defaults = UserDefaults.standard
    var notetype = ""
    var noteString = ""
    var action = ""
    var lastUpdated : Int64!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        notesbackground.layer.cornerRadius = 5
        notestextview.layer.borderWidth = 1
        notestextview.layer.borderColor = UIColor.lightGray.cgColor
        notestextview.layer.cornerRadius = 5
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(self.donepressed))
        toolbar.setItems([flexSpace,doneButton], animated: true)
        notestextview.inputAccessoryView = toolbar
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        print("handleTap")
        notestextview.resignFirstResponder()
    }
    
    func donepressed() {
        notestextview.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.bringSubview(toFront: notesbackground)
        self.view.bringSubview(toFront: titlelabel)
        if let themeclr = UserDefaults.standard.string(forKey: "themeColor"){
            cancelbutton.layer.cornerRadius = 15
            savebutton.layer.cornerRadius = 15
            cancelbutton.layer.borderWidth = 2
            cancelbutton.layer.borderColor = UIColor.init(hex: themeclr).cgColor
            savebutton.layer.borderWidth = 2
            savebutton.layer.borderColor = UIColor.init(hex: themeclr).cgColor
            cancelbutton.setTitleColor(UIColor.init(hex: themeclr), for: .normal)
            savebutton.setTitleColor(UIColor.init(hex: themeclr), for: .normal)
        }
        let appid = self.defaults.string(forKey: "selectedappid")
        let NoteidToStore = "\(appid!)\(NoteID)"
        switch NoteType {
        case "fromAgenda":
            notetype = "agenda"
            if CoreDataManager.checkforAgendaID(id: NoteidToStore){
                noteString = CoreDataManager.GetAgendafromAgendaID(id: NoteidToStore).notesContent!
                notestextview.text = noteString
                action = "update"
            }else{
                action = "create"
            }
        case "fromSponsors":
            notetype = "sponsor"
            if CoreDataManager.checkforSponsorsID(id: NoteidToStore){
                noteString = CoreDataManager.GetSponsorsfromSponsorsID(id: NoteidToStore).notesContent!
                notestextview.text = noteString
                action = "update"
            }else{
                action = "create"
            }
        case "fromExhibitors":
            notetype = "exhibitor"
            if CoreDataManager.checkforExhibitorsID(id: NoteidToStore){
                noteString = CoreDataManager.GetExhibitorsfromExhibitorsID(id: NoteidToStore).notesContent!
                notestextview.text = noteString
                action = "update"
            }else{
                action = "create"
            }
        default:
            print("Deault print")
        }
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        if notestextview.text.characters.count > 0{
            lastUpdated = getCurrentMillis()
            if UserDefaults.standard.value(forKey: "userlogindata") != nil{
                postnotes()
            }else{
                let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                })
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            UIAlertView(title: "OOPS!!!",message:"Notes is empty!" ,delegate: nil,cancelButtonTitle: "OK").show()
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
                      "type": notetype as AnyObject,
                      "type_id": NoteID as AnyObject,
                      "type_name": NoteName as AnyObject,
                      "last_updated": lastUpdated as AnyObject,
                      "notes": notestextview.text as AnyObject,
                      "action": action as AnyObject
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
    
    func updateCoreDataBool() {
        let appid = self.defaults.string(forKey: "selectedappid")
        let NoteidToStore = "\(appid!)\(NoteID)"
        switch NoteType {
        case "fromAgenda":
            CoreDataManager.UpdateBoolforAgendaID(agendaID: NoteidToStore, agendaDidAdd: false)
        case "fromSponsors":
            CoreDataManager.UpdateBoolforSponsorsID(sponsorsID: NoteidToStore, notesDidAdd: false)
        case "fromExhibitors":
            CoreDataManager.UpdateBoolforExhibitorsID(exhibitorsID: NoteidToStore, exhibitorsDidAdd: false)
        default:
            print("Deault print")
        }

    }
    
    func savenotes() {
        let appid = self.defaults.string(forKey: "selectedappid")
        let NoteidToStore = "\(appid!)\(NoteID)"
        switch NoteType {
        case "fromAgenda":
            if CoreDataManager.checkforAgendaID(id: NoteidToStore){
                CoreDataManager.UpdateNotesfromAgendaID(agendaID: NoteidToStore, agendaNotes: notestextview.text, agendaDidAdd: true, lastUpdated: lastUpdated)
            }else{
                CoreDataManager.storeAgendaNotes(agendaID: NoteidToStore, agendaNotes: notestextview.text, agendaDidAdd: true, agendaName: NoteName, lastUpdated: lastUpdated, notesType: notetype)
            }
            
        case "fromSponsors":
            if CoreDataManager.checkforSponsorsID(id: NoteidToStore){
                CoreDataManager.UpdateNotesfromSponsorsID(sponsorsID: NoteidToStore, sponsorsNotes: notestextview.text, sponsorsDidAdd: true, lastUpdated: lastUpdated)
            }else{
                CoreDataManager.storeSponsorsNotes(sponsorsID: NoteidToStore, sponsorsNotes: notestextview.text, sponsorsDidAdd: true, sponsorsName: NoteName, lastUpdated: lastUpdated, notesType: notetype)
            }
            
        case "fromExhibitors":
            if CoreDataManager.checkforExhibitorsID(id: NoteidToStore){
                CoreDataManager.UpdateNotesfromExhibitorsID(exhibitorsID: NoteidToStore, exhibitorsNotes: notestextview.text, exhibitorsDidAdd: true, lastUpdated: lastUpdated)
            }else{
                CoreDataManager.storeExhibitorsNotes(exhibitorsID: NoteidToStore, exhibitorsNotes: notestextview.text, exhibitorsDidAdd: true, exhibitorsName: NoteName, lastUpdated: lastUpdated, notesType: notetype)
            }
            
        default:
            print("Deault print")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
}
