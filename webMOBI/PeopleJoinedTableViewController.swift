//
//  PeopleJoinedTableViewController.swift
//  webMOBI
//
//  Created by webmobi on 5/22/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import ObjectMapper
import SDWebImage

class PeopleJoinedTableViewController: UITableViewController {

    var logindata: [String: Any] = [String: Any]()
    var appid = ""
    var users : [getJoinedPeoples] = [getJoinedPeoples]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.delegate = self
        tableView.register(UINib(nibName: "PeopleJoinedTableViewCell", bundle: nil), forCellReuseIdentifier: "PeopleJoinedTableViewCell")
        
        logindata = UserDefaults.standard.value(forKey: "userlogindata") as!  [String: Any]
        self.tableView.tableFooterView = UIView()
        getpeoples()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnTap = false
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleJoinedTableViewCell", for: indexPath) as! PeopleJoinedTableViewCell
        cell.selectionStyle = .none
        cell.profileimage.layer.cornerRadius = 35
        cell.username.text = users[indexPath.row].first_name! + " " + users[indexPath.row].last_name!
        let imageurl = users[indexPath.row].profile_pic! as String
        if users[indexPath.row].designation!.characters.count > 0{
            cell.userdetail.text = users[indexPath.row].designation! + ", "
        }
        
        if users[indexPath.row].profile_pic!.characters.count > 0{
            cell.profileimage.sd_setImage(with: URL(string: imageurl), placeholderImage: UIImage(named: "profile2"))
        }
        
        if users[indexPath.row].company!.characters.count > 0{
            cell.userdetail.text = (cell.userdetail.text!) + users[indexPath.row].company!
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected", indexPath.row)
        let name = users[indexPath.row].first_name! + users[indexPath.row].last_name!
        let AttendeeDetailView = self.storyboard?.instantiateViewController(withIdentifier: "AttendeeDetailViewController") as! AttendeeDetailViewController
        AttendeeDetailView.attendeeId = users[indexPath.row].userid!
        if(users[indexPath.row].profile_pic!.isEmpty == false)
        {
            AttendeeDetailView.ImgUrl = users[indexPath.row].profile_pic!
            AttendeeDetailView.colorCode = UIColor.white
        }else
        {
            AttendeeDetailView.ImgUrl = ""
            AttendeeDetailView.colorCode = UIColor.gray
        }
        AttendeeDetailView.attendeename = name
        if(users[indexPath.row].designation!.isEmpty == false && users[indexPath.row].company!.isEmpty == false)
        {
            AttendeeDetailView.attendeeDesc = users[indexPath.row].designation! + ", " + users[indexPath.row].company!
        }else if(users[indexPath.row].designation!.isEmpty == false)
        {
            AttendeeDetailView.attendeeDesc = users[indexPath.row].designation!
        }else
        {
            AttendeeDetailView.attendeeDesc = ""
        }
        AttendeeDetailView.appid = appid
        AttendeeDetailView.frompeoplejoined = true
        self.navigationController?.pushViewController(AttendeeDetailView, animated: true)
        
    }
    
}

extension PeopleJoinedTableViewController{

    func getpeoples() {
        getjoinedpeoples(){ receiveddata in
            let response = receiveddata["response"] as! Bool
            DispatchQueue.main.async {
                
                if response == true{
                    
                    let responsedata = receiveddata["responseString"] as! [String: Any]
                    let users = responsedata["users"] as! [AnyObject]

                    for data in users {
                        let data1 = Mapper<getJoinedPeoples>().map(JSONObject: data)
                        self.users.append(data1!)
                        self.tableView.reloadData()
                    }
                    
                }else{
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "Requset Failed", message: receiveddata["responseString"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        })
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
        }
    }

    func getjoinedpeoples(completion: @escaping (_ Data: AnyObject) -> ()) {
        
        var request = URLRequest(url: URL(string: ServerAPIs.get_joined_people + "appid=\(appid)")!)
        request.httpMethod = "GET"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(logindata["token"] as! String, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        let alert = UIAlertController(title: "ERROR CODE: \((error as! NSError).code)", message: (error as! NSError).localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
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
            
            if (statusCode == 200) {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    
                    completion(parsedData as AnyObject)
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }else {
                
            }
        }
        task.resume()
    }

}
