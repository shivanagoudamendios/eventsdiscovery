//
//  ExtesionFile.swift
//  webMOBI
//
//  Created by webmobi on 5/18/17.
//  Copyright © 2017 Webmobi. All rights reserved.
//

import UIKit

public class TimeConversion {
    
    func stringfrommilliseconds(ms: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: (ms / 1000.0))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
    func localtimestringfrommilliseconds(ms: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: (ms / 1000.0))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func stringfromdate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
    
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}
extension UITextField {
    func setBottomBorder() {
        let border = CALayer()
        let width = CGFloat(0.3)
        border.borderColor = UIColor(red: 39/255, green: 148/255, blue: 165/255, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UITextView {
    func setBottomBorder() {
        let border = CALayer()
        let width = CGFloat(0.3)
        border.borderColor = UIColor(red: 39/255, green: 148/255, blue: 165/255, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 1) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func addLoader() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.tag = 1000
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        
        let imageName = "loading"
        let image = UIImage(named: imageName)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintedImage!)
        imageView.tintColor = UIColor.white
        imageView.frame = CGRect(x: self.frame.midX-25, y: self.frame.midY-25, width: 50, height: 50)
        imageView.tag = 404
        imageView.rotate360Degrees(duration: 1)
        self.addSubview(imageView)
        
    }
    
    func removeLoader() {
        
        if let loaderview = self.viewWithTag(404){
            loaderview.removeFromSuperview()
        }else{
            print("No Loader Activated")
        }
        if let Blurview = self.viewWithTag(1000){
            Blurview.removeFromSuperview()
        }else{
            print("No Loader Activated")
        }
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    mutating func trim() ->String
    {
        return self.trimmingCharacters(in: .whitespaces)
    }
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    func html2AttributedStringWithFontSize(fontsize: Int) -> NSAttributedString
    {
        let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontsize)\">%@</span>" as NSString, self) as String
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        return attrStr
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}


extension UIImage {
    
    func toBase64() -> String{
        let imageData =  UIImageJPEGRepresentation(self, 0)
        return imageData!.base64EncodedString(options: NSData.Base64EncodingOptions())
    }
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
}
}
extension UIViewController{
    func setupLayoutImage(_ view: UIView){
        // Reading Value
        
        
        let bannerImageView = UIImageView(image: #imageLiteral(resourceName: "bannerImage"))
        self.view.addSubview(bannerImageView)
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        bannerImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        bannerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bannerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true
//        bannerImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bannerImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        bannerImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        bannerImageView.clipsToBounds = true
        bannerImageView.contentMode = .scaleToFill
        
    }
}
