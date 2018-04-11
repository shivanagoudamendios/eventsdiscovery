//
//  NotesViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/19/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    var notesDidAdd : [Bool] = [Bool]()
    var notesID: [String] = [String]()
    var lastUpdated: [Int64] = [Int64]()
    var notesString :[String] = [String]()
    var notesName :[String] = [String]()
    var notesType :[String] = [String]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let myCellNib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        homeCollectionView.register(myCellNib, forCellWithReuseIdentifier: "MyCollectionViewCell")
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
        }
        self.title = "My Notes"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllNotes()
        self.setNavigationBarItem()
        homeCollectionView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        notesDidAdd.removeAll()
        notesID.removeAll()
        lastUpdated.removeAll()
        notesString.removeAll()
        notesName.removeAll()
        notesType.removeAll()
    }

    func getAllNotes() {
        let AgendaNote = CoreDataManager.fetchAgendaNotes()
        let appid = self.defaults.string(forKey: "selectedappid")
        for a in AgendaNote{
            let idToStore = "\(a.notesID!)"
            let notesContent = a.notesString!
            if (notesContent.characters.count > 0) && (idToStore.contains(appid!)){
                let originalID = idToStore.replacingOccurrences(of: appid!, with: "")
                notesDidAdd.append(a.notesDidAdd!)
                notesID.append(originalID)
                lastUpdated.append(a.lastUpdated!)
                notesString.append(a.notesString!)
                notesName.append(a.notesName!)
                notesType.append(a.notesType!)
            }
        }
        
        let sponsorsNote = CoreDataManager.fetchSponsorsNotes()
        for a in sponsorsNote{
            let idToStore = "\(a.notesID!)"
            let notesContent = a.notesString!
            if (notesContent.characters.count > 0) && (idToStore.contains(appid!)){
                let originalID = idToStore.replacingOccurrences(of: appid!, with: "")
                notesDidAdd.append(a.notesDidAdd!)
                notesID.append(originalID)
                lastUpdated.append(a.lastUpdated!)
                notesString.append(a.notesString!)
                notesName.append(a.notesName!)
                notesType.append(a.notesType!)
            }
        }
        
        let exhibitorsNote = CoreDataManager.fetchExhibitorsNotes()
        for a in exhibitorsNote{
            let idToStore = "\(a.notesID!)"
            let notesContent = a.notesString!
            if (notesContent.characters.count > 0) && (idToStore.contains(appid!)){
                let originalID = idToStore.replacingOccurrences(of: appid!, with: "")
                notesDidAdd.append(a.notesDidAdd!)
                notesID.append(originalID)
                lastUpdated.append(a.lastUpdated!)
                notesString.append(a.notesString!)
                notesName.append(a.notesName!)
                notesType.append(a.notesType!)
            }
        }
    }

}
extension NotesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func individualWidthGivenTotalItems(numberOfItems: CGFloat) -> CGFloat {
        
        if numberOfItems == 0 {
            return 0
        }
        let collectionViewWidth = homeCollectionView.bounds.size.width
        let inset: CGFloat = 0.0
        let width: CGFloat = floor((collectionViewWidth - (numberOfItems - 1) * inset) / numberOfItems)
        return width
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        
        cell.configCell(notesName[indexPath.row], content: notesString[indexPath.row])
        cell.lastupdated.text = TimeConversion().stringfrommilliseconds(ms: Double(lastUpdated[indexPath.row]), format: "dd MMM hh:mm a")
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let notesDetailsController = self.storyboard?.instantiateViewController(withIdentifier: "NotesDetailViewController") as! NotesDetailViewController
        notesDetailsController.notestitle = notesName[indexPath.row]
        notesDetailsController.notesText = notesString[indexPath.row]
        notesDetailsController.notesID = notesID[indexPath.row]
        notesDetailsController.notesType = notesType[indexPath.row]
        self.present(notesDetailsController, animated: true, completion: nil)
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 2
        let width = individualWidthGivenTotalItems(numberOfItems: numberOfCells)
        return CGSize(width: width, height: width * 3 / 2)
        
    }
}
