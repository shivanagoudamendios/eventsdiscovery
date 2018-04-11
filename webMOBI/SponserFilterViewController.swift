//
//  SponserFilterViewController.swift
//  FractalAnalytics
//
//  Created by Gnani Naidu on 6/22/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
class SponserFilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnsView: UIView!
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    var delegate : changeOptionDelegate!
    let defaults = UserDefaults.standard
    var selectedList :[String] = []
    var categories : [Categories] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        if let themeclr = defaults.string(forKey: "themeColor"){
            clearAllBtn.setTitleColor(UIColor(hex:themeclr), for: .normal)
            doneBtn.setTitleColor(UIColor(hex:themeclr), for: .normal)
            clearAllBtn.addTarget(self, action: #selector(self.clearBtnAction), for: .touchUpInside)
            doneBtn.addTarget(self, action: #selector(self.doneBtnAction), for: .touchUpInside)
        }
        
        tableView.register(UINib(nibName: "SponsorsFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "SponsorsFilterTableViewCell")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
        self.navigationController!.view.superview!.layer.cornerRadius = 10
        btnsView.layer.borderWidth = 0.5
        btnsView.layer.borderColor = UIColor.lightGray.cgColor
        btnsView.clipsToBounds = true
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 55
        //        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.layer.borderWidth = 0.5
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.clipsToBounds = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.isNavigationBarHidden = false
        }
        super.viewWillDisappear(animated)
    }

    func clearBtnAction(sender : UIButton){
    delegate?.changeOption(selectdata: [])
    self.dismiss(animated: true, completion: nil)
    }
    
    func doneBtnAction(sender : UIButton){
        
        delegate?.changeOption(selectdata: selectedList)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SponserFilterViewController: UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let nib = UINib(nibName: "resultCell", bundle: nil)
        //        tableView.registerNib(nib, forCellReuseIdentifier:"ResultViewCell")
        
        let cell: SponsorsFilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SponsorsFilterTableViewCell") as! SponsorsFilterTableViewCell
        cell.setcolorforcategory(color: categories[indexPath.row].color_code!, category: categories[indexPath.row].category!)
        let themeclr = defaults.string(forKey: "themeColor")
        if(selectedList.contains(categories[indexPath.row].category!))
        {
            cell.checkImg?.image = UIImage(named:"check")?.maskWithColor(color: UIColor(hex:themeclr!))
        }else
        {
            cell.checkImg?.image = UIImage(named:"uncheck")?.maskWithColor(color: UIColor(hex:themeclr!))
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        if(selectedList.contains(categories[indexPath.row].category!)){
            selectedList =  selectedList.filter(){$0 != categories[indexPath.row].category!}
        }else
        {
            selectedList.append(categories[indexPath.row].category!)
        }
        tableView.reloadData()
        
        
    }
    

}
