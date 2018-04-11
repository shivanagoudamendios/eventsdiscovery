//
//  SponsorsViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 4/26/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import MBProgressHUD

protocol changeOptionDelegate {
    func changeOption(selectdata:[String])
}

class SponsorsViewController: UITableViewController,changeOptionDelegate,UIPopoverPresentationControllerDelegate{
    
    var sponserArray = [AnyObject]()
    var sponsersFilterArray = [AnyObject]()
    var sponserArray1 = [AnyObject]()
    var categories = [Categories]()
    var categoriesWithColor = [String : String]()
    var selectedList = [String]()
    let defaults = UserDefaults.standard;
    
    var hud = MBProgressHUD()
    let cache = ImageLoadingWithCache()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedList = []
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        tableView.register(UINib(nibName: "SponsersTableViewCell", bundle: nil), forCellReuseIdentifier: "SponsersTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.lightGray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeOption(selectdata:[String])
    {
        sponsersFilterArray.removeAll()
        selectedList = selectdata
        if(selectdata.count > 0)
        {
            if((defaults.value(forKey: "sponsortype") as! Bool)){
                let arr =  sponserArray as? [SponsorsDataItems]
                
                for item in arr! {
                    
                    if(selectdata.contains(item.categories!))
                    {
                        sponsersFilterArray.append(item)
                        
                    }
                }
                
            }else
            {
                let arr =  sponserArray as? [ExhibitorsDataItems]
                
                for item in arr! {
                    
                    if(selectdata.contains(item.categories!))
                    {
                        sponsersFilterArray.append(item)
                        
                    }
                }
            }
            
        }else
        {
            sponsersFilterArray = sponserArray
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if((defaults.value(forKey: "sponsortype") as! Bool == true)){
            if((defaults.value(forKey: "favtype") as! Bool) != true)
            {
                if let dataFromDefaults = defaults.object(forKey: "sponsorsData") as? NSData{
                    if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? SponsorsData{
                        
                        sponserArray = objectFromDefaults.items!
                        sponsersFilterArray = objectFromDefaults.items!
                        categories = objectFromDefaults.categories
                        categoriesWithColor.removeAll()
                        for category in categories{
                        
                            categoriesWithColor[category.category!] =  category.color_code!
                        }
                        tableView.reloadData()
                    }
                }
            }else
            {  categoriesWithColor.removeAll()
                var myfavArray = [AnyObject]()
                if let dataFromDefaults = defaults.object(forKey: "sponsorsData") as? NSData{
                    if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as Data) as? SponsorsData{
                        
                        let favList : [Int64] = CoreDataManager.GetAllSponsorsFavorites()
                        
                        categories = objectFromDefaults.categories
                        for category in categories{
                            
                            categoriesWithColor[category.category!] =  category.color_code!
                        }
                        
                        for item in objectFromDefaults.items!
                        {
                            if(favList.contains(item.sponsor_id!)){
                                myfavArray.append(item)
                                
                            }
                        }
                        
                    }
                }
                if let dataFromDefaults = defaults.object(forKey: "exhibitorsData"){
                    if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                        
                        let objectFromDefaults = Mapper<ExhibitorsData>().map(JSONObject: dataAtIndex)
                        
                        let favList : [Int64] = CoreDataManager.GetAllExhibitorFavorites()
                        
                       categories = objectFromDefaults!.categories
                        for category in categories{
                            
                            categoriesWithColor[category.category!] =  category.color_code!
                        }
                        
                        for item in objectFromDefaults!.items!{
                            if(favList.contains(item.exhibitor_id!)){
                                myfavArray.append(item)
                            }
                        }
                    }
                }
                sponserArray = myfavArray
                sponsersFilterArray = sponserArray
                tableView.reloadData()
            }
        }else{
            if let dataFromDefaults = defaults.object(forKey: "exhibitorsData"){
                if let dataAtIndex = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                    
                    let objectFromDefaults = Mapper<ExhibitorsData>().map(JSONObject: dataAtIndex)
                    sponserArray = objectFromDefaults!.items!
                    sponsersFilterArray = objectFromDefaults!.items!
                    categories = objectFromDefaults!.categories
                    categoriesWithColor.removeAll()
                    for category in categories{
                        
                        categoriesWithColor[category.category!] =  category.color_code!
                    }
                    tableView.reloadData()
                }
            }
        }
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        super.viewWillAppear(animated)
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {if((defaults.value(forKey: "sponsortype") as! Bool == true) && (defaults.value(forKey: "favtype") as! Bool) == true)
            {
                self.setNavigationBarItem()
            }else
            {
                self.setLeftNavigationBarItem()
                
                var image = UIImage(named: "Filter")
                
                image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.rightBtnAction))
            }
        }
        //        if(self.defaults.bool(forKey: "login"))
        //        {
        //
        //            let appid = self.defaults.string(forKey: "selectedappid")
        //            let email = self.defaults.string(forKey: "Useremail")
        //
        //            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //            hud.labelText = "Loading Data..."
        //            hud.minSize = CGSize(width: 150, height: 100)
        //
        //            DispatchQueue.main.async(execute: {() -> Void in
        //
        //                let urlPath: String = ServerApis.FavoriteUrl+"appId="+appid!+"&email="+email!
        //                let urlStr : String = urlPath.addingPercentEscapes(using: .utf8)!
        //                let url: NSURL = NSURL(string: urlStr as String)!
        //                let request1 = NSMutableURLRequest(
        //                    url: url as URL,
        //                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
        //                    timeoutInterval: 15.0)
        //
        //                NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: OperationQueue(), completionHandler:{
        //                    (response, data, error)-> Void in
        //
        //                    if(error != nil)
        //                    {
        //                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
        //                            DispatchQueue.main.async(execute: {() -> Void in
        //                                self.hud.hide(true, afterDelay: 0)
        //                            })
        //                        })
        //                    }else
        //                    {
        //
        //                    do {
        //                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
        //
        //                            print("Synchronous\(jsonResult)")
        //
        //                            let dataAtIndex = jsonResult["companies"] as! [AnyObject]
        //
        //                            if((self.defaults.value(forKey: "favtype") as! Bool) == true && (self.defaults.value(forKey: "sponsortype") as! Bool))
        //                            {
        //                                self.sponserArray = dataAtIndex
        //                            }
        //                            self.sponserArray1 = dataAtIndex
        //
        //
        //                            //                        if((self.defaults.valueForKey("sponsortype") as! Bool))
        //                            //                        {
        //                            //                           self.sponserArray = dataAtIndex
        //                            //                        }else
        //                            //                        {
        //                            //                           self.sponserArray1 = dataAtIndex
        //                            //                        }
        //
        //                            DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
        //                                DispatchQueue.main.async(execute: {() -> Void in
        //                                    self.hud.hide(true, afterDelay: 0)
        //                                    self.tableView.reloadData()
        //                                })
        //                            })
        //
        //
        //                        }
        //                    } catch let error as NSError {
        //                        print(error.localizedDescription)
        //                        DispatchQueue.global(qos: .userInitiated).async(execute: {() -> Void in
        //                            DispatchQueue.main.async(execute: {() -> Void in
        //                                self.hud.hide(true, afterDelay: 0)
        //                                self.tableView.reloadData()
        //                            })
        //                        })
        //                    }
        //
        //
        //
        //                }
        //                })
        //            })
        //
        //        }
        
        
    }
    
    func rightBtnAction()
    {
        
        let controller: SponserFilterViewController = self.storyboard!.instantiateViewController(withIdentifier: "SponserFilterViewController") as! SponserFilterViewController
        controller.delegate = self
        controller.categories = categories
        controller.selectedList = selectedList
        let nav: UINavigationController = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = nav.popoverPresentationController!
        controller.preferredContentSize = CGSize(width: self.view.frame.size.width-40, height: self.view.frame.size.height-92)
        popover.delegate = self
        popover.sourceView = self.view!
        popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popover.permittedArrowDirections =  UIPopoverArrowDirection(rawValue: 0)
        self.present(nav, animated: true, completion: { _ in })
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        view.backgroundColor = UIColor.white
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .none
    }
    
    func getDataFromUrl(url:NSURL, completion: @escaping ((_ data: NSData?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
            }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return   sponsersFilterArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        
        let cell: SponsersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SponsersTableViewCell") as! SponsersTableViewCell
        if((defaults.value(forKey: "sponsortype") as! Bool)){
            if((defaults.value(forKey: "favtype") as! Bool))
            {
                let arr = sponsersFilterArray[indexPath.row] as? SponsorsDataItems
                if(arr != nil)
                {
                    cell.titleLabel.text = arr!.company!
                    cell.urlLabel.text = arr!.website!
                    cell.setcolorforcategory(color: categoriesWithColor[arr!.categories!]!, category: arr!.categories!)
                    
                    let imgurl = (arr!.image!)
                    if(imgurl.length > 0){
                        DispatchQueue.main.async() { () -> Void in
                            
                            self.cache.getImage(url: imgurl, imageView:  cell.imgView, defaultImage: "NoImage")
                        }
                    }else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            cell.imgView.image = UIImage(named:"NoImage")
                        })
                    }
                }else
                {
                    let arr =  sponsersFilterArray[indexPath.row] as? ExhibitorsDataItems
                    if(arr != nil)
                    {
                        cell.titleLabel.text = arr!.company!
                        cell.urlLabel.text = arr!.website!
                        cell.setcolorforcategory(color: categoriesWithColor[arr!.categories!]!, category: arr!.categories!)
                        let imgurl = (arr!.image!)
                        if(imgurl.length > 0){
                            DispatchQueue.main.async() { () -> Void in
                                self.cache.getImage(url: imgurl, imageView:  cell.imgView, defaultImage: "NoImage")
                            }
                        }else
                        {
                            DispatchQueue.main.async(execute: { () -> Void in
                                cell.imgView.image = UIImage(named:"NoImage")
                            })
                        }
                    }
                }
            }else
            {
                let arr =  sponsersFilterArray as? [SponsorsDataItems]
                if(arr != nil)
                {
                    cell.titleLabel.text = arr![indexPath.row].company!
                    cell.urlLabel.text = arr![indexPath.row].website!
                    
                    cell.setcolorforcategory(color: categoriesWithColor[arr![indexPath.row].categories!]!, category: arr![indexPath.row].categories!)
                    
                    let imgurl = (arr![indexPath.row].image!)
                    if(imgurl.length > 0){
                        DispatchQueue.main.async() { () -> Void in
                            self.cache.getImage(url: imgurl, imageView:  cell.imgView, defaultImage: "NoImage")
                        }
                    }else
                    {
                        DispatchQueue.main.async(execute: { () -> Void in
                            cell.imgView.image = UIImage(named:"NoImage")
                        })
                    }
                }
            }
            
        }
        else {
            let arr =  sponsersFilterArray as? [ExhibitorsDataItems]
            if(arr != nil)
            {
                cell.titleLabel.text = arr![indexPath.row].company!
                cell.urlLabel.text = arr![indexPath.row].website!
                cell.setcolorforcategory(color: categoriesWithColor[arr![indexPath.row].categories!]!, category: arr![indexPath.row].categories!)
                let imgurl = (arr![indexPath.row].image!)
                if(imgurl.length > 0){
                    DispatchQueue.main.async() { () -> Void in
                        self.cache.getImage(url: imgurl, imageView:  cell.imgView, defaultImage: "NoImage")
                    }
                }else
                {
                    DispatchQueue.main.async(execute: { () -> Void in
                        cell.imgView.image = UIImage(named:"NoImage")
                    })
                }
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if((defaults.value(forKey: "sponsortype") as! Bool == true)){
            
            if((defaults.value(forKey: "favtype") as! Bool))
            {
                let arr = sponsersFilterArray[indexPath.row] as? SponsorsDataItems
                if(arr != nil)
                {
                    let SponsorDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "SponersandExhibitorsDetailViewController") as! SponersandExhibitorsDetailViewController
                    SponsorDetailsView.fromFav = true
                    SponsorDetailsView.spnsorDetails = arr
                    SponsorDetailsView.categoryColor = categoriesWithColor[arr!.categories!]!
                    SponsorDetailsView.title = "Details"
                    SponsorDetailsView.fromSponsor = true
                    self.navigationController?.pushViewController(SponsorDetailsView, animated: true)
                    
                }else
                {
                    let arr =  sponsersFilterArray[indexPath.row] as? ExhibitorsDataItems
                    if(arr != nil)
                    {
                        let exhibitorDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "SponersandExhibitorsDetailViewController") as! SponersandExhibitorsDetailViewController
                        exhibitorDetailsView.fromFav = true
                        exhibitorDetailsView.title = "Details"
                        exhibitorDetailsView.exhibitorDetails = arr
                        exhibitorDetailsView.categoryColor = categoriesWithColor[arr!.categories!]!
                        exhibitorDetailsView.fromSponsor = false
                        self.navigationController?.pushViewController(exhibitorDetailsView, animated: true)
                    }
                    
                }
                
            }else
            {
                let arr = sponsersFilterArray[indexPath.row] as? SponsorsDataItems
                let SponsorDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "SponersandExhibitorsDetailViewController") as! SponersandExhibitorsDetailViewController
                SponsorDetailsView.spnsorDetails = sponsersFilterArray[indexPath.row] as? SponsorsDataItems
                SponsorDetailsView.title = "Details"
                SponsorDetailsView.fromSponsor = true
                SponsorDetailsView.fromFav = false
                SponsorDetailsView.categoryColor = categoriesWithColor[arr!.categories!]!
                self.navigationController?.pushViewController(SponsorDetailsView, animated: true)
            }
            
        }else {
            let arr = sponsersFilterArray[indexPath.row] as? ExhibitorsDataItems
            let exhibitorDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "SponersandExhibitorsDetailViewController") as! SponersandExhibitorsDetailViewController
            exhibitorDetailsView.title = "Details"
            exhibitorDetailsView.fromFav = false
            exhibitorDetailsView.exhibitorDetails = sponsersFilterArray[indexPath.row] as? ExhibitorsDataItems
            exhibitorDetailsView.fromSponsor = false
            exhibitorDetailsView.categoryColor = categoriesWithColor[arr!.categories!]!
            self.navigationController?.pushViewController(exhibitorDetailsView, animated: true)
            
        }
    }
    
    
    
    
}



