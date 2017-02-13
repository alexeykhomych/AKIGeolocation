//
//  AKILocation.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/13/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

struct AKICoordinates {
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    init(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longtitude
    }
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
    }
}

class AKILocation {
    
    var coordinates: AKICoordinates?
    
    init(_ coordinates: AKICoordinates) {
        self.coordinates = coordinates
    }
    
    func locationDidChange(_ locations: [CLLocation]) {
        let location = locations.last
        let latitude = (location?.coordinate.latitude)!
        let longitude = (location?.coordinate.longitude)!
        
        self.coordinates = AKICoordinates(latitude: latitude, longtitude: longitude)
    }
    
    func comparePositions(_ firstCoordinates: AKICoordinates, secondCoordinates: AKICoordinates) -> Bool {
        let distance = firstCoordinates.location().distance(from: secondCoordinates.location())
        
        return distance >= 100 ? true : false
    }
    
}
