//
//  EventsTableViewCell.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit
import FontAwesome_swift
class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var app_name_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var moredetailbutton: UIButton!
    @IBOutlet weak var downloadeventbutton: UIButton!
    @IBOutlet weak var discoverymoreDetailBtn: UIButton!
    @IBOutlet weak var eventview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventview.layer.cornerRadius = 5
        eventview.layer.masksToBounds = false
        eventview.layer.shadowColor = UIColor.black.cgColor
        eventview.layer.shadowOpacity = 0.7
        eventview.layer.shadowOffset = CGSize(width: 1, height: 1)
        eventview.layer.shadowRadius = 2
        
        downloadeventbutton.imageView?.contentMode = .scaleAspectFit
        
        favBtn.layer.cornerRadius = 2
    }
    
    func changefavbtnlogo(addedinFav : Bool)
    {   if(addedinFav)
    {
        let img = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-heart")!, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        favBtn.setImage(img, for: .normal)
        favBtn.tintColor = UIColor.red
    }else
    {
        let img = UIImage.fontAwesomeIcon(name: FontAwesome.fromCode("fa-heart-o")!, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        favBtn.setImage(img, for: .normal)
        favBtn.tintColor = UIColor.white
        }
    }
    
    func checkfileExistornot(filename: String)
    {
        DownloadEvent().checkfileExist(_filename:filename){ existflag in
            if(existflag)
            {
                self.downloadeventbutton.setImage(nil, for: .normal)
                self.downloadeventbutton.isEnabled = false
            }else
            {
                self.downloadeventbutton.setImage(UIImage(named:"previewicon"), for: .normal)
                self.downloadeventbutton.isEnabled = true
            }
        }
    }
    
    @IBAction func downloadeventAction(_ sender: UIButton) {
        
    }
    
    @IBAction func moredetailAction(_ sender: UIButton) {
        
    }
    
    func resizeImage(image: UIImage!, newWidth: CGFloat) -> UIImage {
        
        //        let scale = newWidth / image.size.width
        //        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
