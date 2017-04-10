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
    
    var replaySubject: Signal?
    var timerInterval: Int?
    var locationAccuracy: CLLocationAccuracy?
    var distanceFilter: CLLocationDistance?
    
    private let replaySubjectBufferCount = 1
    private let disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager().defaultManager()
    private var coordinate:CLLocationCoordinate2D?
    
    private var location: Driver<CLLocationCoordinate2D>?
    
    // MARK: - Initializations and Deallocations

    init() {
        self.replaySubject = Signal.create(bufferSize: self.replaySubjectBufferCount)
    }
    
    // MARK: - Public methods
    
    func initManager() {
        self.initTimer()
        self.susbcribeToUpdateLocations()
    }
    
    // MARK: - Public methods
    
    func requestWhenInUseAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func isAuthorizated() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        return status != .denied && status != .notDetermined ? true : false
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
