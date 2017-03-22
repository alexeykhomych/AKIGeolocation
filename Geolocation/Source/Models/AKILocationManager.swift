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
    
    // MARK: Accessors
    
    var replaySubject: ReplaySubject<[CLLocation]>?
    
    private let defaultLatitude = 0.0
    private let defaultLongitude = 0.0
    private let replaySubjectBufferCount = 1
    
    private let disposeBag = DisposeBag()
    
    private var locationManager: CLLocationManager?
    
    var timerInterval: Int?
    
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
    
    // MARK: Initializations and Deallocations

    override init() {
        self.replaySubject = ReplaySubject<[CLLocation]>.create(bufferSize: self.replaySubjectBufferCount)
        super.init()
        self.locationManager = self.defaultManager()
        self.initTimer()
    }
    
    // MARK: Public methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.sendLocationsForSubscribers(locations)
    }
    
    // MARK: Private methods
    
    private func initTimer() {
        _ = Observable<Int>
            .interval(RxTimeInterval(self.timerInterval ?? Timer.Default.interval), scheduler: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .observeOn(MainScheduler.instance)
            .subscribe({ [weak self] _ in
                let coordinate = self?.coordinate
                
                guard let longitude = coordinate?.longitude,
                    let latitude = coordinate?.latitude else
                {
                    return
                }
                
                self?.sendLocationsForSubscribers([CLLocation(latitude: latitude, longitude: longitude)])
            }).addDisposableTo(self.disposeBag)
    }
    
    private func sendLocationsForSubscribers(_ locations: [CLLocation]) {
        _ = self.replaySubject?.onNext(locations)
    }
}
