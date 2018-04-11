//
//  BannerAdsViewController.swift
//  webMOBI
//
//  Created by webmobi on 28/03/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit

class BannerAdsViewController: UIViewController {
    
        override func viewDidLoad() {
            super.viewDidLoad()
          //  setupLayoutImage()
            
        }
        func setupLayoutImage(){
            let bannerImageView = UIImageView(image: #imageLiteral(resourceName: "bannerImage"))
            self.view.addSubview(bannerImageView)
            bannerImageView.translatesAutoresizingMaskIntoConstraints = false
            bannerImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            bannerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            bannerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
            bannerImageView.heightAnchor.constraint(equalToConstant: 50).isActive = false
            bannerImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
            bannerImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
            bannerImageView.clipsToBounds = true
            bannerImageView.contentMode = .scaleToFill
            
        }
        //        bannerImageView.widthAnchor.constraint(equalToConstant: 50).isActive = false
        //        bannerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //        bannerImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        
}

