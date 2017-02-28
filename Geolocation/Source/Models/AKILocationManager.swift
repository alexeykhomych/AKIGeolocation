//
//  AKILocationManager.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/27/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

import RxCocoa
import RxSwift

protocol AKIGoogleLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}

extension AKIGoogleLocationManager {
    func defaultManager() -> CLLocationManager {
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
}

class AKILocationManager: NSObject, AKIGoogleLocationManager {
    
    var replaySubject: ReplaySubject<[CLLocation]> = ReplaySubject<[CLLocation]>.create(bufferSize: 1)
    
    var isMoving: Bool = false
    
    private var locationManager: CLLocationManager?
    
    var locations: [CLLocation]? {
        return [CLLocation(latitude: self.latitude!,
                           longitude: self.longitude!)]
    }
    
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
    
    override init() {
        super.init()
        self.locationManager = self.defaultManager()
    }
    
    init(_ manager: CLLocationManager) {
        self.locationManager = manager
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = self.replaySubject.onNext(locations)
    }
}
