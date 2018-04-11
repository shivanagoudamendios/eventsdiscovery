//
//  Artwork.swift
//  WebmobiEvents
//
//  Created by webmobi on 4/11/16.

import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        //        let addressDict = ""
        //[String(kABPersonAddressStreetKey): self.subtitle]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
}