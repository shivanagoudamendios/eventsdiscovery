//
//  MapsViewController.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/14/16.
//  Copyright © 2016 webmobi. All rights reserved.
//

import UIKit
import MapKit
import ObjectMapper

class MapsViewController: UIViewController {
    
    @IBOutlet var mapFullScreenView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var artworks = [Artwork]()
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapFullScreenView.setRegion(coordinateRegion, animated: true)
    }
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        
        
        let borderColor: UIColor = UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
        
        mapFullScreenView.layer.borderColor = borderColor.cgColor
        mapFullScreenView.layer.borderWidth = 1.0
        mapFullScreenView.layer.cornerRadius = 5.0
        
        
        super.viewDidLoad()
    }
    func showLocDetails(mapDescription : String,latitude : Double,longitude : Double){
        let artwork = Artwork(title: mapDescription,
                              locationName: mapDescription,
                              discipline: "",
                              coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
        mapFullScreenView.addAnnotation(artwork)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let dataFromDefaultInNsData = defaults.object(forKey: "mapData") as? NSData{
            if let mapData = NSKeyedUnarchiver.unarchiveObject(with: dataFromDefaultInNsData as Data) as? Maps{
                let mapDescription1 = mapData.venue
                let latitude = Double((mapData.lat)!)
                let longitude = Double((mapData.lng)!)
                let initialLocation = CLLocation(latitude: latitude!, longitude: longitude!)
                centerMapOnLocation(location: initialLocation)
                showLocDetails(mapDescription: mapDescription1!,latitude: latitude!,longitude: longitude!)
            }
        }
        
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
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
