//
//  NewImageHeaderView.swift
//  FractalAnalytics
//
//  Created by webmobi on 6/7/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import UIKit
import ObjectMapper

class NewImageHeaderView : UIView {
    
    @IBOutlet weak var logowidth: NSLayoutConstraint!
    @IBOutlet weak var logoheight: NSLayoutConstraint!
    @IBOutlet weak var logoimage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var backgroundImage : UIImageView!
    let defaults = UserDefaults.standard;
    var appsponserUrl = ""
    var sponsorArray = [SponsorsDataItems]()
    var exiArray = [ExhibitorsDataItems]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "E0E0E0")
        
        self.backgroundImage.backgroundColor = UIColor.white
        self.backgroundImage.alpha = 0.3
        if let appid = defaults.string(forKey: "selectedappid"){
            let testFile1 = FileSaveHelper(fileName: appid, fileExtension: .JSON, subDirectory: "SavingFiles", directory: .documentDirectory)

            do {
                let str =  try testFile1.getContentsOfFile()
                let data = str.data(using: String.Encoding.utf8, allowLossyConversion: false)
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    let locationicon = String.fontAwesomeIcon(code: "fa-map-marker")
                    location.font = UIFont.fontAwesome(ofSize: 13)
                    location.text = locationicon! + "  " + (jsonResult!["location"] as? String)!
                    appName.text = jsonResult!["appName"] as? String
                    backgroundImage.sd_setImage(with: URL(string: (jsonResult!["appLoadingImage"] as? String)!), placeholderImage: UIImage(named: "placeholder.png"))
                    logoimage.sd_setImage(with: URL(string: (jsonResult!["appLogo"] as? String)!), placeholderImage: UIImage(named: "placeholder.png"))
                } catch {
                    print("json error: \(error)")
                }
                
                
            }catch {
                print (error)
            }
        }
        
    }
}
