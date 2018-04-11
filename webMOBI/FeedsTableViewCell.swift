//
//  FeedsTableViewCell.swift
//  FractalAnalytics
//
//  Created by webmobi on 1/3/18.
//  Copyright © 2018 webmobi. All rights reserved.
//

import UIKit
import SDWebImage

class FeedsTableViewCell: UITableViewCell {

    @IBOutlet weak var ImagesSetsHeight: NSLayoutConstraint!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postDescriptionTextView: UITextView!
    @IBOutlet weak var postedViewForImages: UIView!
    @IBOutlet weak var likeButton1: UIButton!
    @IBOutlet weak var likeButton2: UIButton!
    @IBOutlet weak var commentButton1: UIButton!
    @IBOutlet weak var commentButton2: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addImagesToView(images: [FeedsAttachments]) {
        for view in postedViewForImages.subviews{
            if view.tag == 1{
                view.removeFromSuperview()
            }
        }
        if images.count == 1{
            let myImageView = UIImageView()
            myImageView.frame = postedViewForImages.bounds
            myImageView.tag = 1
            myImageView.contentMode = .scaleAspectFill
            myImageView.clipsToBounds = true
            myImageView.sd_setImage(with: URL(string: images[0].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            postedViewForImages.addSubview(myImageView)
        }else if images.count == 2{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height)  //postedViewForImages.bounds
            myImageView.contentMode = .scaleAspectFill
            myImageView.sd_setImage(with: URL(string: images[0].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView.clipsToBounds = true
            postedViewForImages.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: postedViewForImages.frame.midX, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.sd_setImage(with: URL(string: images[1].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView1.clipsToBounds = true
            postedViewForImages.addSubview(myImageView1)
            
        }else if images.count == 3{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView.contentMode = .scaleAspectFill
            myImageView.sd_setImage(with: URL(string: images[0].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView.clipsToBounds = true
            postedViewForImages.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: postedViewForImages.frame.midX, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.sd_setImage(with: URL(string: images[1].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView1.clipsToBounds = true
            postedViewForImages.addSubview(myImageView1)
            
            let myImageView2 = UIImageView()
            myImageView2.tag = 1
            myImageView2.frame = CGRect(x: 0, y: postedViewForImages.frame.height/2, width: postedViewForImages.frame.width, height: postedViewForImages.frame.height/2)
            myImageView2.contentMode = .scaleAspectFill
            myImageView2.sd_setImage(with: URL(string: images[2].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView2.clipsToBounds = true
            postedViewForImages.addSubview(myImageView2)
        }else if images.count == 4{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView.contentMode = .scaleAspectFill
            myImageView.sd_setImage(with: URL(string: images[0].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView.clipsToBounds = true
            postedViewForImages.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: postedViewForImages.frame.midX, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.sd_setImage(with: URL(string: images[1].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView1.clipsToBounds = true
            postedViewForImages.addSubview(myImageView1)
            
            let myImageView2 = UIImageView()
            myImageView2.tag = 1
            myImageView2.frame = CGRect(x: 0, y: postedViewForImages.frame.height/2, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView2.contentMode = .scaleAspectFill
            myImageView2.sd_setImage(with: URL(string: images[2].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView2.clipsToBounds = true
            postedViewForImages.addSubview(myImageView2)
            
            let myImageView3 = UIImageView()
            myImageView3.tag = 1
            myImageView3.frame = CGRect(x: postedViewForImages.frame.midX, y: postedViewForImages.frame.height/2, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView3.contentMode = .scaleAspectFill
            myImageView3.sd_setImage(with: URL(string: images[3].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView3.clipsToBounds = true
            postedViewForImages.addSubview(myImageView3)
        }else if images.count > 4{
            let myImageView = UIImageView()
            myImageView.tag = 1
            myImageView.frame = CGRect(x: 0, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView.contentMode = .scaleAspectFill
            myImageView.sd_setImage(with: URL(string: images[0].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView.clipsToBounds = true
            postedViewForImages.addSubview(myImageView)
            
            let myImageView1 = UIImageView()
            myImageView1.tag = 1
            myImageView1.frame = CGRect(x: postedViewForImages.frame.midX, y: 0, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView1.contentMode = .scaleAspectFill
            myImageView1.sd_setImage(with: URL(string: images[1].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView1.clipsToBounds = true
            postedViewForImages.addSubview(myImageView1)
            
            let myImageView2 = UIImageView()
            myImageView2.tag = 1
            myImageView2.frame = CGRect(x: 0, y: postedViewForImages.frame.height/2, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView2.contentMode = .scaleAspectFill
            myImageView2.sd_setImage(with: URL(string: images[2].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView2.clipsToBounds = true
            postedViewForImages.addSubview(myImageView2)
            
            let myImageView3 = UIImageView()
            myImageView3.tag = 1
            myImageView3.frame = CGRect(x: postedViewForImages.frame.midX, y: postedViewForImages.frame.height/2, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            myImageView3.contentMode = .scaleAspectFill
            myImageView3.sd_setImage(with: URL(string: images[3].res_url!), placeholderImage: UIImage(named: "placeholder.png"))
            myImageView3.clipsToBounds = true
            postedViewForImages.addSubview(myImageView3)
            
            let myView = UIView()
            myView.tag = 1
            myView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            myView.frame = CGRect(x: postedViewForImages.frame.midX, y: postedViewForImages.frame.height/2, width: postedViewForImages.frame.width/2, height: postedViewForImages.frame.height/2)
            let mylabel = UILabel()
            mylabel.frame = myView.bounds
            mylabel.textAlignment = .center
            mylabel.contentMode = .center
            mylabel.textColor = UIColor.white
            mylabel.text = "+\(images.count - 4)"
            mylabel.font = UIFont.systemFont(ofSize: 30)
            myView.addSubview(mylabel)
            myView.clipsToBounds = true
            postedViewForImages.addSubview(myView)
        }
    }
    
}
