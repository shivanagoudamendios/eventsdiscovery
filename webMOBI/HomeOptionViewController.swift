//
//  HomeOptionViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/22/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit


class HomeOptionViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate  {
 
    @IBOutlet weak var homeoptiontableview: UITableView!
 
   //    @IBOutlet weak var proView: UIView!
//    @IBOutlet weak var favView: UIView!
//    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var optionviewforTG: UIView!     //ForTapGesture
//    @IBOutlet weak var optionview: UIView!
    var delegate : openFavouritesTVC!
    let data1 = ["Profile", "Popular","Favourite Events", "Help"]
    let data2 = ["Log In", "Help"]
    
    let data_image = ["profileunselected","popular","favevents","help"]
    let data_image_2 = ["loginColored","help"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
//        tap.delegate = self
//        self.optionviewforTG.addGestureRecognizer(tap)
        homeoptiontableview.delegate = self
        homeoptiontableview.dataSource = self
//        let optionview_tap = UITapGestureRecognizer(target: self, action: #selector(self.handleOptionViewTap(sender:)))
//        optionview_tap.delegate = self
//        self.optionview.addGestureRecognizer(optionview_tap)
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = optionviewforTG.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        optionviewforTG.addSubview(blurEffectView)
//        optionviewforTG.fadeIn()
//        setShadowToview(view: optionview)
        let nib = UINib.init(nibName: "MoreOptionTableViewCell", bundle: nil)
        homeoptiontableview.register(nib, forCellReuseIdentifier: "MoreOptionTableViewCell")
        
        
        homeoptiontableview.tableFooterView = UIView()
    }
    
    func handlefavTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: {
            
            self.delegate.openfavourites()
        })
        print("Favourite Tapped")
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromTop
//        self.optionview.layer.add(transition, forKey: nil)
//        self.optionview.fadeOut()
        self.optionviewforTG.fadeOut()
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
 //       self.optionview.layer.add(transition, forKey: kCATransition)
//        let userdata = UserDefaults.standard.value(forKey: "userlogindata")
//        if userdata == nil{
//            let alert = UIAlertController(title: "Not Logged in", message: "Login Required", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default){
//                UIAlertAction in
//                self.tabBarController?.selectedIndex = 0
//            })
//            self.present(alert, animated: true, completion: nil)
//        }
        homeoptiontableview.reloadData()
        
     }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = .white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(UserDefaults.standard.value(forKey: "userlogindata")  == nil)
        {
            return 2
            
        }
        else
        {
            return 4
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreOptionTableViewCell", for: indexPath) as! MoreOptionTableViewCell

        if(UserDefaults.standard.value(forKey: "userlogindata")  == nil){
           
            cell.labelCellView.text = data2[indexPath.row]
            cell.imageCellView.image = UIImage(named: data_image_2[indexPath.row])
        } else {
            cell.labelCellView.text = data1[indexPath.row]
            cell.imageCellView.image = UIImage(named: data_image[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell", data1[indexPath.row])
        
        var storyboard = UIStoryboard()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else {
            storyboard = UIStoryboard(name: "Main_iPhone", bundle: nil)
        }
        if(UserDefaults.standard.value(forKey: "userlogindata")  == nil){
            switch  indexPath.row {
            case 0:
                let nextVC = storyboard.instantiateViewController(withIdentifier: "WelcomeScreen") as! WelcomeScreen
                self.present(nextVC, animated: true, completion: nil)
            case 1:
                print("Help Tapped")
            default:
                print("default Tapped")
            }
        } else  {
            switch  indexPath.row {
            case 0:
                let nextVC = storyboard.instantiateViewController(withIdentifier: "NewMySettingsViewController") as! NewMySettingsViewController
                        self.navigationController?.pushViewController(nextVC, animated: true)
            case 1:
                    print("Popular Events")
                    
                    let newViewController = HomeTabViewController3(nibName: "HomeTabViewController3", bundle: nil)
                   self.navigationController?.pushViewController(newViewController, animated: true)
                 //   self.present(newViewController,animated: true, completion: nil)
            case 2:
                print("Favourite Tapped")
                let newViewController = FavoritesTableViewController(nibName: "FavoritesTableViewController", bundle: nil)
                self.navigationController?.pushViewController(newViewController, animated: true)
              //   self.present(newViewController,animated: true, completion: nil)
            case 3:
                print("case 3")
            default:
                print("default Tapped")
            }
        }
            
   }
    
    func setShadowToview(view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: -2, height: 0)
        view.layer.shadowRadius = 2
    }
 
//    func handleOptionViewTap(sender: UITapGestureRecognizer){
//        let fav_tap = UITapGestureRecognizer(target: self, action: #selector(self.handlefavTap(sender:)))
//        fav_tap.delegate = self
//        self.favView.addGestureRecognizer(fav_tap)
//
//
//        let pro_tap = UITapGestureRecognizer(target: self, action: #selector(self.handleproTap(sender:)))
//        pro_tap.delegate = self
//        self.proView.addGestureRecognizer(pro_tap)
//
//
//        let pop_tap = UITapGestureRecognizer(target: self, action: #selector(self.handlepopTap(sender:)))
//        pop_tap.delegate = self
//        self.popView.addGestureRecognizer(pop_tap)
//    }
    
//    func reload(tableView: UITableView) {
//
//        let contentOffset = homeoptiontableview.contentOffset
//        homeoptiontableview.reloadData()
//        homeoptiontableview.layoutIfNeeded()
//        homeoptiontableview.setContentOffset(contentOffset, animated: false)
//
//    }
}
