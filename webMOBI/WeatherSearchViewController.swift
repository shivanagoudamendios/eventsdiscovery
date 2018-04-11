//
//  WeatherSearchViewController.swift
//  WebmobiEvents
//
//  Created by Gnani Naidu on 5/9/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class WeatherSearchViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var weatherSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherSearchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if let city : AnyObject = searchBar.text as AnyObject?{
            let tagflag = ["cityName": city]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cityNameIs"), object: nil, userInfo: tagflag)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
