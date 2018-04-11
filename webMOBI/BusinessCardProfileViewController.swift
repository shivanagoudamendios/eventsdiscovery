//
//  BusinessCardProfileViewController.swift
//  webMOBI
//
//  Created by webmobi on 28/02/18.
//  Copyright © 2018 Webmobi. All rights reserved.
//

import UIKit
import SDWebImage
class BusinessCardProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var businessscrollview: UIScrollView!
//    var image:UIImage!
  
    @IBOutlet weak var detailsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var businessSV: UIScrollView!
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    var businessDetailView : businessCard = businessCard()
    var Contactstruct:[String] = []
    var AlternateContactDetailsS:[String] = []
    var contactDetails = ["Company","Designation","Address","Phone no","Email","Website","Fax"]
    var alternateContactDetails = ["Phone no","Email","Website"]
    var cardDetails = ["Card type"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            Contactstruct.append(businessDetailView.company)
        Contactstruct.append(businessDetailView.designation)
        Contactstruct.append(businessDetailView.address)
        Contactstruct.append(businessDetailView.contact_phone)
        Contactstruct.append(businessDetailView.contact_email)
        Contactstruct.append(businessDetailView.website)
        Contactstruct.append(businessDetailView.fax)
        AlternateContactDetailsS.append(businessDetailView.contact_phone_1)
        AlternateContactDetailsS.append(businessDetailView.contact_email_1)
        AlternateContactDetailsS.append(businessDetailView.website_1)

        self.detailsTableView.estimatedRowHeight = 100.0

        self.detailsTableView.rowHeight = UITableViewAutomaticDimension
        self.cardImage.sd_setImage(with: URL(string: businessDetailView.card_image_url), placeholderImage: UIImage(named : "profileunselected"))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameLabel.text = businessDetailView.contact_first_name
        lastNameLabel.text = businessDetailView.contact_last_name
        descLabel.text = businessDetailView.contact_info
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.detailsTableView.layoutIfNeeded()
            let testSize : CGSize = CGSize(width: self.detailsTableView.bounds.size.width, height:CGFloat.greatestFiniteMagnitude)
            let tableHeight : CGFloat = self.detailsTableView.sizeThatFits(testSize).height
                self.detailsTableViewHeight.constant = tableHeight
            self.view.layoutIfNeeded()
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
        {
            
            return "Contact Details"
        }
        else if(section == 1)
        {
            return "Alternate Contact Details"
        }
        else
        {
            return "Card Details"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
        return 7
        }
        else if(section == 1)
        {
            return 3
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCardProfileTableViewCell") as! BusinessCardProfileTableViewCell
        cell.selectionStyle = .none
        
        if(indexPath.section == 0)
        {
            
            cell.nameLabel.text = contactDetails[indexPath.row]
            cell.nameValueLabel.text = Contactstruct[indexPath.row]
//            cell.nameValueLabel.text = "hgdsagdhgjhghjghjgughdagsdjghsdahgsgdhasfdhafsghdsdsafdgahsfdghsafdghasfdhgaw"
//
            
        }else if(indexPath.section == 1)
        {
            cell.nameLabel.text = alternateContactDetails[indexPath.row]
            cell.nameValueLabel.text = AlternateContactDetailsS[indexPath.row]
           
        }else
        {
            cell.nameLabel.text = cardDetails[indexPath.row]
            cell.nameValueLabel.text = businessDetailView.card_type
           
        }
        return cell
    }

  
}
