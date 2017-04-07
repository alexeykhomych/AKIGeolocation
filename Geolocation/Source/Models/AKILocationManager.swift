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
    
    // MARK: - Accessors
    
    typealias Signal = ReplaySubject<Result<[CLLocation], LocationError>>
    
    static let instance = AKILocationManager()
    
    var replaySubject: Signal?
    var timerInterval: Int?
    var locationAccuracy: CLLocationAccuracy?
    var distanceFilter: CLLocationDistance?
    
    private let replaySubjectBufferCount = 1
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    private var authorized: Driver<Bool>?
    private var location: Driver<CLLocationCoordinate2D>?
    
    // MARK: - Initializations and Deallocations

    init() {
        self.replaySubject = Signal.create(bufferSize: self.replaySubjectBufferCount)
    }
    
    // MARK: - Public methods
    
    func initManager() {
        let locationManager = self.locationManager
        
        self.authorized = Observable.deferred { [weak locationManager] in
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
        
        locationManager.distanceFilter = self.distanceFilter ?? kCLDistanceFilterNone
        locationManager.desiredAccuracy = self.locationAccuracy ?? kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.initTimer()
        self.susbcribeToUpdateLocations()
    }
    
    // MARK: - Private methods
    
    private func susbcribeToUpdateLocations() {
        self.location = self.locationManager.rx.didUpdateLocations
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        self.startNotifications()
    }
    
    private func initTimer() {
        _ = Observable<Int>
            .interval(RxTimeInterval(self.timerInterval ?? Timer.Default.interval), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] time in
                self?.combineResults(time: time, event: nil)
            }.addDisposableTo(self.disposeBag)
    }
    
    private func startNotifications() {
        _ = self.location?.drive(onNext: { [weak self] in
            self?.combineResults(time: nil, event: RxSwift.Event.next($0))
        })
    }
    
    private var coordinate:CLLocationCoordinate2D?
        
    private func combineResults(time: RxSwift.Event<Int>?, event:  RxSwift.Event<CLLocationCoordinate2D>?) {
        Observable.combineLatest(Observable.just(time), Observable.just(event)) { r1, r2 -> CLLocationCoordinate2D? in
            return r2?.element ?? self.coordinate
            }
            .subscribe(onNext: { coordinate in
                guard let latitude = coordinate?.latitude,
                    let longitude = coordinate?.longitude else {
                        _ = self.replaySubject?.onNext(.failure(.description("vse polomalos")))
                        return
                }
                
                self.coordinate = coordinate
                
                let array = [CLLocation(latitude: latitude, longitude: longitude)]
                _ = self.replaySubject?.onNext(.success(array))
            }).disposed(by: self.disposeBag)
    }
}
