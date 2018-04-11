//
//  LeaderBoardViewController.swift
//  webMOBI
//
//  Created by webmobi on 21/02/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var attendeeTableView: UITableView!
    @IBOutlet weak var leaderPoints: UILabel!
    @IBOutlet weak var leaderName: UILabel!
    @IBOutlet weak var leaderImage: UIImageView!
    
    var leaderboard1 : [leaderboardProperties] = []
    let defaults = UserDefaults.standard
    var leaderboard : [leaderboardProperties] = []
    var userid : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.attendeeTableView.separatorStyle = .none
        self.attendeeTableView.delegate = self
        self.attendeeTableView.dataSource = self
        getLeaderBoardData()
        setLeaderBoardProperties()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.bringSubview(toFront: leaderPoints)
        self.view.bringSubview(toFront: leaderName)
        self.view.bringSubview(toFront: leaderImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        let themeclr = defaults.string(forKey: "themeColor")
        //        self.navigationController?.navigationBar.barTintColor = UIColor.red
        //        self.navigationController?.navigationBar.tintColor = .white
        //        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blue]
        if let themeclr = defaults.string(forKey: "themeColor"){
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: themeclr)
            
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        if(defaults.value(forKey: "fromhome") as! Bool == false)
        {
            self.setLeftNavigationBarItem()
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Scorers"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section : Int) -> UIView{
    ////        let headerView = UIView()
    ////        headerView.backgroundColor = UIColor.black
    ////
    ////        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:
    ////            tableView.bounds.size.width/20, height: tableView.bounds.size.height/20))
    ////        headerLabel.font = UIFont(name: "Verdana", size: 20)
    ////        headerLabel.textColor = UIColor.white
    ////        //headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
    ////        headerLabel.sizeToFit()
    ////        headerView.addSubview(headerLabel)
    //
    //
    //
    ////        return headerView
    //    }
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "Top Scorers"
    //    }
    //    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let vw = UIView()
    //        vw.backgroundColor = UIColor.red
    //
    //        return vw
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let themeclr = defaults.string(forKey: "themeColor")
        let cell: LeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeaderTableViewCell",for : indexPath) as! LeaderTableViewCell
        //cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.attendeeName.text = leaderboard1[indexPath.row].user_name
        cell.attendeeImage.sd_setImage(with: URL(string: leaderboard1[indexPath.row].user_image), placeholderImage: UIImage(named: "EmptyUser")!)
        cell.attendeeRanking.text = String(leaderboard1[indexPath.row].user_points)
        cell.attendeeNumber.text = String(indexPath.row + 1)
        
        // Setting
        cell.attendeeImage.layer.cornerRadius = cell.attendeeImage.frame.width/2
        cell.attendeeImage.clipsToBounds = true
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.attendeeRanking.layer.cornerRadius = 10
        cell.attendeeRanking.clipsToBounds = true
        
        if((indexPath.row + 1) == 1){
            cell.attendeeNumber.layer.backgroundColor = UIColor.yellow.cgColor
        } else{
            cell.attendeeNumber.layer.backgroundColor = UIColor.gray.cgColor
        }
        
        
        cell.attendeeNumber.layer.borderColor = UIColor.black.cgColor
        cell.attendeeNumber.layer.borderWidth = 0.7
        
        cell.attendeeRanking.layer.cornerRadius = 5
        cell.attendeeRanking.layer.backgroundColor = UIColor(hex: themeclr!).cgColor
        cell.attendeeRanking.textColor = .white
        return cell
    }
    
    
    
    func getLeaderBoardData(){
        let appid = self.defaults.string(forKey: "selectedappid")!
        //        let data1 = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        //        let userId = data1["userId"]! as! String
        userid = defaults.string(forKey: "EvntUserId")!
        let half_url = ServerApis.getleaderboard + "?userid=" + userid + "&checkvalue=gamification1" +  "&appid=" + appid
        //        let url = half_url + "&userid=" + userid.description
        print(half_url)
        let request = NSMutableURLRequest(url: NSURL(string: half_url)! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
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
                    if ((json["response"] as! Bool) == true){
                        let responseString = json["responseString"]!
                        let questionarray1 =  json["users"] as! [NSDictionary]
                        
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                //                                    self.rateThisIcon.isHidden = false
                                //                                    self.rateThisIcon.rating = responseString as! Float
                                // UserDefaults.standard.set(data, forKey: json)
                                for item in questionarray1
                                {
                                    var question:leaderboardProperties = leaderboardProperties()
                                    question.user_id = item["userid"] as! String
                                    question.user_name = item["first_name"]  as! String
                                    question.user_name += item["last_name"] as! String
                                    question.user_points = item["total_points"] as! Int
                                    question.user_image = item["profile_pic"] as! String
                                    
                                    self.leaderboard.append(question)
                                    // self.questiontableviewheight.constant = CGFloat(self.quest.count * 40)
                                    self.leaderboard = self.leaderboard.sorted{$0.user_points >  $1.user_points }
                                    self.leaderboard1 = self.leaderboard.filter{$0.user_id != self.userid}
                                    self.attendeeTableView.reloadData()
                                    self.setLeaderBoardProperties()
                                    //                                    self.viewDidLayoutSubviews()
                                    self.view.removeLoader()
                                }
                            })
                        })
                    }else{
                        let responseString = json["responseString"] as! String
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.removeLoader()
                                let alert = UIAlertController(title: "Request Failed", message: "Data could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                    UIAlertAction in
                                })
                                self.present(alert, animated: true, completion: nil)
                            })
                        })
                    }
                }catch {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.removeLoader()
                            let alert = UIAlertController(title: "Request Failed", message: "Data could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                            })
                            self.present(alert, animated: true, completion: nil)
                        })
                    })
                }
                

            }else{
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.removeLoader()
                        let alert = UIAlertController(title: "Request Failed", message: "Data could not be updated.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                })
            }
        })
        task.resume()
    }
    
    func setLeaderBoardProperties(){
        let themeclr = defaults.string(forKey: "themeColor")
        
        self.leaderImage.layer.cornerRadius = self.leaderImage.frame.width/2
        self.leaderImage.clipsToBounds = true
        self.leaderPoints.layer.backgroundColor = UIColor(hex: themeclr!).cgColor
        self.leaderPoints.textColor = .white
        self.leaderPoints.layer.cornerRadius = 5.0
        let uname = leaderboard.filter{$0.user_id == userid}
        if(uname.count > 0)
        {
            self.leaderName.text = uname[0].user_name
            self.leaderPoints.text = "\(uname[0].user_points)"
            self.leaderImage.sd_setImage(with: URL(string: uname[0].user_image), placeholderImage: UIImage(named: "EmptyUser")!)
        }
        
        
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

