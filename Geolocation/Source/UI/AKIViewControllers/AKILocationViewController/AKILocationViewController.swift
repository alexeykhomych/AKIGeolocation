//
//  AKILocationViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

import FBSDKLoginKit

import Firebase
import FirebaseAuth

import RxSwift
import RxCocoa

protocol AKILocationViewControllerProtocol {
    func subscribeCurrentPositionContext(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees)
    func observForMoving()
    func initTimer()
    func logOut()
}

class AKILocationViewController: UIViewController, AKILocationViewControllerProtocol {
    deinit {
        print("dsd")
    }
    var viewModel: AKIViewModel?
    
    private var timer: Disposable?
    
    private let disposeBag = DisposeBag()
    
    private var locationManager: AKILocationManager?
    
    private let logoutButtonText = "Log out"
    
    private var locationView: AKILocationView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initLeftBarButtonItem()
        self.initTimer()
        self.initLocationManager()
        self.initMapView()
        self.observForMoving()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func initLocationManager() {
        self.locationManager = AKILocationManager()
    }
    
    private func initLeftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: self.logoutButtonText,
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(logOut))
        
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        self.navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.logOut()
            }).addDisposableTo(self.disposeBag)
    }
    
    private func initMapView() {
        let mapView = self.locationView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    func initTimer() {
        _ = Observable<Int>
            .interval(RxTimeInterval(Timer.Default.interval), scheduler: ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .subscribe({ [weak self] _ in
                let coordinate = self?.locationManager?.coordinate
                guard let latitude = coordinate?.latitude else {
                    return
                }
                
                guard let longitude = coordinate?.longitude else {
                    return
                }
                
                self?.subscribeCurrentPositionContext(longitude, latitude: latitude)
            }).addDisposableTo(self.disposeBag)
    }
    
    func subscribeCurrentPositionContext(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let context = AKICurrentPositionContext(viewModel, latitude: latitude, longitude: longitude)
        let observer = context.execute().asObservable()
        
        observer
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }).disposed(by: self.disposeBag)
    }
    
    func observForMoving() {
        _ = self.locationManager?
            .replaySubject?
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] locations in
                self?.locationView?.cameraPosition(locations: locations)
            }).addDisposableTo(self.disposeBag)
    }
    
    func logOut() {
        FBSDKLoginManager().logOut()
        try? FIRAuth.auth()?.signOut()
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
