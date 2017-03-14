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
    
    var replaySubject: ReplaySubject<[CLLocation]>?
    
    private let defaultLatitude = 0.0
    private let defaultLongitude = 0.0
    private let replaySubjectBufferCount = 1
    
    private var locationManager: CLLocationManager?
    
    var location: CLLocation? {
        return self.locationManager?.location
    }
    
    var coordinate: CLLocationCoordinate2D? {
        return self.location?.coordinate
    }
    
    var latitude: CLLocationDegrees? {
        return self.unwrap(value: self.coordinate?.latitude, defaultValue: self.defaultLatitude)
    }
    
    var longitude: CLLocationDegrees? {
        return self.unwrap(value: self.coordinate?.longitude, defaultValue: self.defaultLongitude)
    }
    
    override init() {
        self.replaySubject = ReplaySubject<[CLLocation]>.create(bufferSize: self.replaySubjectBufferCount)
        super.init()
        self.locationManager = self.defaultManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = self.replaySubject?.onNext(locations)
    }
}
