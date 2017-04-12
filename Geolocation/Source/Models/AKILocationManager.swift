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
    
    private var location: Observable<[CLLocation]>?
    
    // MARK: - Initializations and Deallocations

    init() {
        self.replaySubject = Signal.create(bufferSize: self.replaySubjectBufferCount)
    }
    
    // MARK: - Public methods
    
    func startObserving() {
        self.combineResults()
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
        
    private func combineResults() {
        let timer = Observable<Int>.interval(RxTimeInterval(self.timerInterval ?? Timer.Default.interval), scheduler: MainScheduler.instance)
        let loc = self.locationManager.rx.didUpdateLocations
        
        _ = Observable.combineLatest(timer, loc) { s1, s2 in
            return s2
            }.subscribe(onNext: { coordinate in
                _ = self.replaySubject?.onNext(.success(coordinate))
            }).disposed(by: self.disposeBag)
    }
}
