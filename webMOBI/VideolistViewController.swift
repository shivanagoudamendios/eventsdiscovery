//
//  VideolistViewController.swift
//  FractalAnalytics
//
//  Created by webmobi on 7/6/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MBProgressHUD
class VideolistViewController: UIViewController {
    
    @IBOutlet weak var awardsTableView: UITableView!
    
    var videoArray = [PdfDetails]()
    let defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        awardsTableView.register(UINib(nibName: "AttachmentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AttachmentsTableViewCell")
        awardsTableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        super.viewWillAppear(animated)
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
        
        let dataFromDefaultsAsNsData = defaults.object(forKey: "videoData") as? NSData
        if let dataFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultsAsNsData! as Data) as? Video
        {
            self.videoArray = dataFromDefaults.items
            
            awardsTableView.reloadData()
        }
        
        
    }
    
}


extension VideolistViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return  self.videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        let themeclr = defaults.string(forKey: "themeColor")
        
        let cell: AttachmentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AttachmentsTableViewCell") as! AttachmentsTableViewCell
        cell.AttachmentTitle.text = self.videoArray[indexPath.row].attachment_name
        
        cell.attachTypeImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-file-video-o")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
        cell.downloadAttachmentImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-angle-right")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let url  = NSURL(string: self.videoArray[indexPath.row].attachment_url!) {
            let videoController = storyboard?.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            videoController.videoUrl = self.videoArray[indexPath.row].attachment_url!
            self.navigationController?.pushViewController(videoController, animated: true)
        }else
        {
            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    UIAlertView(title: "Url Not Valid",message: "Please Enter Valid Url",delegate: nil,cancelButtonTitle: "OK").show()
                })
            })
        }
        
       
        
    }
    
}
