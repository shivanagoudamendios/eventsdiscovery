//
//  SpeakerViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 4/20/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class SpeakerViewController: UIViewController,UISearchBarDelegate  {
    
    @IBOutlet weak var speakerSearch: UISearchBar!
    @IBOutlet weak var speakerTableview: UITableView!
    
    var speckerArray :[SpeakersDataItems] = [SpeakersDataItems]()
    var speckerArray1 :[SpeakersDataItems] = [SpeakersDataItems]()
    let defaults = UserDefaults.standard
    var ImageData = [NSData]()
    let cache = ImageLoadingWithCache()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            speakerSearch.barTintColor = UIColor.init(hex: themeclr)
        }
        speakerSearch.delegate = self
        speakerTableview.tableFooterView = UIView()
        speakerTableview.register(UINib(nibName: "NewSpeakersTableViewCell", bundle: nil), forCellReuseIdentifier: "NewSpeakersTableViewCell")
        
        speakerTableview.tableFooterView = UIView()
        speakerTableview.estimatedRowHeight = 85
        speakerTableview.rowHeight = UITableViewAutomaticDimension
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        speckerArray1.removeAll()
        if(searchText.length > 0)
        {
            for aa in speckerArray
            {
                if(aa.name?.lowercased().contains(searchText.lowercased()))!
                {
                    speckerArray1.append(aa)
                }
            }
            speakerTableview.reloadData()
        }else
        {
            speckerArray1 = speckerArray
            speakerTableview.reloadData()
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        speakerSearch.resignFirstResponder()
        speakerSearch.showsCancelButton = false
        speakerSearch.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if let dataFromDefaults = defaults.object(forKey: "speakersData"){
            if let objectFromDefaults = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaults as! Data){
                let dataAtIndex = Mapper<SpeakersData>().map(JSONObject: objectFromDefaults)?.items
                speckerArray = dataAtIndex!
                speckerArray1 = speckerArray
                speakerTableview.reloadData()
            }
        }
        
        super.viewWillAppear(animated)
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setNavigationBarItem()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDataFromUrl(url:NSURL, completion: @escaping ((_ data: NSData?, _ response: URLResponse?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            completion(data as NSData?, response, error as NSError?)
            }.resume()
    }
    
}
extension SpeakerViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  speckerArray1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewSpeakersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewSpeakersTableViewCell") as! NewSpeakersTableViewCell
        cell.speckerNameLabel.text = speckerArray1[indexPath.row].name!
        DispatchQueue.main.async(execute: {() -> Void in
            if(self.speckerArray1.count > indexPath.row)
            {
                let attrStr = try! NSAttributedString(
                    data: (self.speckerArray1[indexPath.row].desc!).data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
                cell.speckerDescLabel.attributedText = attrStr
            }
        })
        cell.speckerImageView.layer.cornerRadius = 5;
        let urlstr = speckerArray1[indexPath.row].image!
        if(urlstr.length > 0) {
            DispatchQueue.main.async(execute: { () -> Void in
                self.cache.getImage(url: urlstr, imageView:  cell.speckerImageView, defaultImage: "EmptyUser.png")
            })
        }else
        {
            DispatchQueue.main.async(execute: { () -> Void in
                cell.speckerImageView.image = UIImage(named: "EmptyUser.png")
            })
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.defaults.setValue( speckerArray1[indexPath.row].name!, forKey: "speakername")
        //        self.defaults.setValue( speckerArray1[indexPath.row].desc!, forKey: "speakerdesc")
        //        self.defaults.setValue( speckerArray1[indexPath.row].image!, forKey: "speakerimgurl")
        //        self.defaults.setValue( speckerArray1[indexPath.row].details!, forKey: "aboutspeaker")
        //        self.defaults.setValue( speckerArray1[indexPath.row].speakerId!, forKey: "speakerId")
        //
        //
        //        let speakerAgendaData = speckerArray1[indexPath.row].agendaId
        //        let nsdataobj = NSKeyedArchiver.archivedData(withRootObject: speakerAgendaData!)
        //        self.defaults.set(nsdataobj, forKey: "selectedSpeakeragenda")
        //        //        self.defaults.setValue( , forKey: "selectedSpeaker")
        //
        //        let speckerPageView = self.storyboard?.instantiateViewController(withIdentifier: "SpeakerDetailsController") as! SpeakerDetailsController
        //        self.navigationController?.pushViewController(speckerPageView, animated: true)
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewSpeakerDetailsViewController") as! NewSpeakerDetailsViewController
        nextViewController.speakersDetail = speckerArray1[indexPath.row]
        nextViewController.fromspeakers = true
        nextViewController.title = "Details"
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
}

