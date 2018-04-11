//
//  VenueViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/11/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MapKit
import ObjectMapper

class VenueViewController: UIViewController {
    @IBOutlet var txtViewMapLocationDesc: UITextView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var btnToGetDirections: UIButton!
    
    let regionRadius: CLLocationDistance = 1000
    var artworks = [Artwork]()
    var locationPlaceMark : MKPlacemark?
    var locationName : String?
    let defaults = UserDefaults.standard
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    override func viewDidLoad() {
        
        //let borderColor: UIColor = UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        
//        mapView.layer.borderColor = borderColor.CGColor
//        mapView.layer.borderWidth = 1.0
//        mapView.layer.cornerRadius = 5.0
        
//        btnToGetDirections.layer.borderColor =  UIColor.redColor().CGColor //borderColor.CGColor
//        btnToGetDirections.layer.borderWidth = 1.0
        btnToGetDirections.layer.cornerRadius = 5.0
        
        if let dataFromDefaultInNsData = defaults.object(forKey: "mapData") as? NSData{
            if let mapData = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultInNsData as Data) as? Maps{
                
                let mapDescription1 = mapData.venue
                locationName = mapDescription1
                let mapDescription2 = try! NSAttributedString(
                    data:(mapData.desc)! .data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                    options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                    documentAttributes: nil)
                txtViewMapLocationDesc.textAlignment = .center
                let mapDesc = mapDescription1! + "\n\n" + mapDescription2.string
                txtViewMapLocationDesc.text = mapDesc
                let latitude = Double((mapData.lat)!)
                let longitude = Double((mapData.lng)!)
                let initialLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                locationPlaceMark = MKPlacemark(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!), addressDictionary: nil)
                centerMapOnLocation(location: initialLocation)
                mapView.delegate = self
                showLocDetails(mapDescription: mapDescription1!,latitude: latitude!,longitude: longitude!)
            }
        }
        
        super.viewDidLoad()
        
    }
    func showLocDetails(mapDescription : String,latitude : Double,longitude : Double){
        let artwork = Artwork(title: mapDescription,
                              locationName: mapDescription,
                              discipline: "",
                              coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        mapView.addAnnotation(artwork)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        if let themeclr = defaults.string(forKey: "themeColor"){
            btnToGetDirections.backgroundColor = UIColor(hex:themeclr)
//            btnToGetDirections.setTitleColor(UIColor.init(hex: themeclr), forState: .Normal)
        }
        
    }
    
    @IBAction func openMaps(sender: AnyObject) {
        let mapItem = MKMapItem(placemark: locationPlaceMark!)
        mapItem.name = locationName
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
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
