//
//  AwardsListViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 9/24/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
import MBProgressHUD
class AwardsListViewController: UIViewController {

    @IBOutlet weak var awardsTableView: UITableView!
    
    var awardsArray = [Pdfurl]()
    var PdfArray = [String : [PdfDetails]]()
    let defaults = UserDefaults.standard
    var hud = MBProgressHUD()
    var sectiontitle : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        
        awardsTableView.register(UINib(nibName: "NewAgendaSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "NewAgendaSectionHeaderView")
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
        
        let dataFromDefaultsAsNsData = defaults.object(forKey: "pdfData") as? NSData
        if let dataFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultsAsNsData! as Data) as? Pdf
        {
            let ItemsArray = dataFromDefaults.pdfurl
            
            for item in ItemsArray{
                sectiontitle.append(item.name!)
            }
            
            for item in ItemsArray{
              PdfArray[item.name!] = item.details
            }
            
            awardsTableView.reloadData()
        }
        
        
    }

    func checkAttachmentInLocal(title : String,type : String)-> String{
    
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent((title+"."+type))?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            return filePath!
        } else {
            return ""
        }
    }

}


extension AwardsListViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return PdfArray.count
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewAgendaSectionHeaderView") as! NewAgendaSectionHeaderView
        view.sectiontitle.text = sectiontitle[section]
        return view
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = sectiontitle[section]
        return  (self.PdfArray[key]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        let themeclr = defaults.string(forKey: "themeColor")
        
        let key = sectiontitle[indexPath.section]
        
        let cell: AttachmentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AttachmentsTableViewCell") as! AttachmentsTableViewCell
         cell.AttachmentTitle.text = self.PdfArray[key]?[indexPath.row].attachment_name
        
        cell.attachTypeImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-file-pdf-o")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
        if(checkAttachmentInLocal(title: (self.PdfArray[key]?[indexPath.row].attachment_name)!,type: (self.PdfArray[key]?[indexPath.row].attachment_type)!).characters.count > 0){
            cell.downloadAttachmentImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-check-circle-o")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
            
        }else
        {
            cell.downloadAttachmentImg.image = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-download")!, textColor: UIColor(hex:themeclr!), size: CGSize(width: 30, height: 30))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let key = sectiontitle[indexPath.section]
        
        if (checkAttachmentInLocal(title: (self.PdfArray[key]?[indexPath.row].attachment_name)!,type: (self.PdfArray[key]?[indexPath.row].attachment_type)!).characters.count > 0)
        {
            
            let localUrl = checkAttachmentInLocal(title: (self.PdfArray[key]?[indexPath.row].attachment_name)!,type: (self.PdfArray[key]?[indexPath.row].attachment_type)!)
            
            let AwardsView = self.storyboard?.instantiateViewController(withIdentifier: "AwardsViewController") as! AwardsViewController
                AwardsView.title = (self.PdfArray[key]?[indexPath.row].attachment_name)!
                AwardsView.urlString = localUrl
            self.navigationController?.pushViewController(AwardsView, animated: true)
        }
        else
        {
            if let url = self.PdfArray[key]?[indexPath.row].attachment_url
            {
                self.hud.hide(true, afterDelay: 0)
                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.labelText = "Downloading..."
                hud.minSize = CGSize(width: 150, height: 100)
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                let yourURL = URL(string: url)
                // turn it into a request and use NSData to load its content
                let request = URLRequest(url: yourURL!)
                let data: Data? = try? NSURLConnection.sendSynchronousRequest(request, returning: nil)
                // find Documents directory and append your local filename
                var documentsURL: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
                let title = (self.PdfArray[key]?[indexPath.row].attachment_name!)!+"."+(self.PdfArray[key]?[indexPath.row].attachment_type!)!
                documentsURL = documentsURL?.appendingPathComponent(title)
                // and finally save the file
                try? data?.write(to: documentsURL!, options: .atomic)
                        self.hud.hide(true, afterDelay: 0)
                        tableView.reloadData()
                    })
                })
            }
        }
        
        
        
        
        
    }
    
}
