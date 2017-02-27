//
//  AKILocationManager.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/27/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

class AKILocationManager: NSObject, CLLocationManagerDelegate {
    
    var isMoving: Bool = false
    
    private var locationManager: CLLocationManager?
    
    var location: CLLocation? {
        return self.locationManager?.location
    }
    
    var coordinate: CLLocationCoordinate2D? {
        return self.location?.coordinate
    }
    
    var latitude: CLLocationDegrees? {
        return self.coordinate?.latitude
    }
    
    var longitude: CLLocationDegrees? {
        return self.coordinate?.longitude
    }
    
    var locations: [CLLocation]? {
        return [CLLocation(latitude: (self.latitude)!,
                           longitude: (self.longitude)!)]
    }
    
    override init() {
        super.init()
        self.locationManager = self.defaultManager()
    }
    
    init(_ manager: CLLocationManager) {
        self.locationManager = manager
    }
    
    private func defaultManager() -> CLLocationManager {
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = CLLocationDistance(Google.Maps.Default.distanceFilter)
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
        
        return manager
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var isMoving = self.isMoving
        isMoving = true
        
//        self.locationView?.cameraPosition(locations: locations)
//        self.writeLocationToDB(locations: locations)
        
        isMoving = false
    }

}
