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

import Result

enum LocationError: Error {
    case description(String)
}

class AKILocationManager {
    
    // MARK: Accessors
    
    typealias Signal = ReplaySubject<Result<[CLLocation], LocationError>>
    
    static let instance = AKILocationManager()
    
    var replaySubject: Signal?
    
    private let defaultLatitude = 0.0
    private let defaultLongitude = 0.0
    private let replaySubjectBufferCount = 1
    
    private let disposeBag = DisposeBag()
    
    private var locationManager = CLLocationManager()
    
    var timerInterval: Int?
    
    var authorized: Driver<Bool>
    var location: Driver<CLLocationCoordinate2D>
    
    var timer: Driver<Int>?
    
    // MARK: Initializations and Deallocations

    init() {
        self.replaySubject = Signal.create(bufferSize: self.replaySubjectBufferCount)
        
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways:
                    return true
                default:
                    return false
                }
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        location = locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
//        self.initTimer()
    }
    
    // MARK: - Public methods
    
    
    
    // MARK: - Private methods
    
    private func initTimer() {
//        self.timer = Observable<Int>
        _ = Observable<Int>
            .interval(RxTimeInterval(self.timerInterval ?? Timer.Default.interval), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] p in
                let coordinate = self?.locationManager.location?.coordinate
                
                guard let longitude = coordinate?.longitude,
                    let latitude = coordinate?.latitude else
                {
                    self?.replaySubject?.onNext(.failure(.description("Coordinates are empty")))
                    return
                }
                
                self?.sendLocationsForSubscribers([CLLocation(latitude: latitude, longitude: longitude)])
            }.addDisposableTo(self.disposeBag)
    }
    
    private func sendLocationsForSubscribers(_ locations: [CLLocation]) {
        _ = self.replaySubject?.onNext(.success(locations))
    }
    
    private func combineResults() {
        //Observable.combineLatest(a, b) { $0 + $1 }
//        let currentHours:Variable<Float> = Variable(0.0)
//        let currentRate:Variable<Float>  = Variable(0.0)
//        
//        let hoursAndRate = Observable.combineLatest(currentHours.asObservable(), currentRate.asObservable()){
//            return $0 + $1
//        }
        
//        Observable.combineLatest(self.location, self.timer) {
//            $0 + $1
//        }
//        
//        self.replaySubject?.onNext()
    }
}
