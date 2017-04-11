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
        _ = self.locationManager.rx.didUpdateLocations.subscribe(onNext: { _ in
            self.combineResults()
        })
    }
    
    private func initTimer() {
        _ = Observable<Int>
            .interval(RxTimeInterval(self.timerInterval ?? Timer.Default.interval), scheduler: MainScheduler.instance)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] time in
//                self?.combineResults(time: time, event: nil)
            }.addDisposableTo(self.disposeBag)
    }
        
    private func combineResults() {
        let timer = Observable<Int>.interval(RxTimeInterval(self.timerInterval ?? Timer.Default.interval), scheduler: MainScheduler.instance)
        let loc = self.locationManager.rx.didUpdateLocations
        
        Observable.combineLatest(Observable.just(timer), Observable.just(loc)) { s1, s2 in
            return s2
            }
            .subscribe(onNext: { coordinate in
                guard let coordinate = coordinate else {
                    _ = self.replaySubject?.onNext(.failure(.description("vse polomalos")))
                    return
                }
                
                _ = coordinate.map { coord in
                    _ = self.replaySubject?.onNext(.success(coord.first?.coordinate))
                }
                print("")
//                guard let coordinate = coordinate else {
//                    _ = self.replaySubject?.onNext(.failure(.description("vse polomalos")))
//                    return
//                }
//                
//                _ = self.replaySubject?.onNext(.success(coordinate))
            }).disposed(by: self.disposeBag)
    }
}
