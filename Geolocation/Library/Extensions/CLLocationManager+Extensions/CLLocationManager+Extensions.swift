//
//  CLLocationManager+Extensions.swift
//  Geolocation
//
//  Created by Alexey Khomych on 4/10/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationManager {
    func defaultManager() -> CLLocationManager {
        let manager = CLLocationManager()
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        return manager
    }
}
