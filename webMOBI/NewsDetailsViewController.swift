//
//  NewsDetailsViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/25/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    @IBOutlet var txtViewNewsDescription: UITextView!
    @IBOutlet var lblNewsItemDate: UILabel!
    @IBOutlet var lblAuthor: UILabel!
    @IBOutlet var txtViewNewsTitle: UITextView!
    
    let defaults = UserDefaults.standard;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        txtViewNewsTitle.text = defaults.object(forKey: "newsDataTitle") as? String
        let author = defaults.object(forKey: "newsDataAuthor") as? String
        lblAuthor.text = "by " + author!
        lblNewsItemDate.text = defaults.object(forKey: "newsDataPublishDate") as? String
        let newsData = defaults.object(forKey: "newsDataContent") as? String
        
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.txtViewNewsDescription.attributedText = try! NSAttributedString(
                data: newsData!.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
        })
        txtViewNewsDescription.layer.borderColor = UIColor.black.cgColor
        txtViewNewsDescription.layer.borderWidth = 0.5
        txtViewNewsDescription.layer.cornerRadius = 5
    }
}
