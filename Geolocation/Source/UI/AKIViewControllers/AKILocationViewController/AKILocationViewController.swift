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

class AKILocationViewController: AKIViewController, CLLocationManagerDelegate {
    
    var isMoving: Bool = false
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    let isRunning = Variable(true)
    
    let logoutButtonText = "Log out"
    
    var locationView: AKILocationView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContext()
        self.initLocationManager()
        self.initLeftBarButtonItem()
        self.initMapView()
        self.initTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initContext() {
//        self.context = AKICurrentPositionContext(self.model!)
    }
    
    func initMapView() {
        let mapView = self.locationView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    func initLocationManager() {
        let locationManager = self.locationManager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = CLLocationDistance(Google.Maps.Default.distanceFilter)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func initTimer() {
        self.isRunning.asObservable()
            .flatMapLatest {  isRunning in
                isRunning ? Observable<Int>.interval(RxTimeInterval(Timer.Default.timerInterval),
                                                     scheduler: MainScheduler.instance) : .empty()
            }
            .flatMapWithIndex { (int, index) in Observable.just(index) }
            .subscribe(onNext: { [weak self] _ in
                if (self?.isMoving)! {
                    return
                }
                
                let locationManager = self?.locationManager
                let locations = CLLocation(latitude: (locationManager?.location?.coordinate.latitude)!,
                                           longitude: (locationManager?.location?.coordinate.longitude)!)
                self?.writeLocationToDB(locations: [locations])
            })
            .addDisposableTo(self.disposeBag)
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var isMoving = self.isMoving
        isMoving = true
        
        self.locationView?.cameraPosition(locations: locations)
        self.writeLocationToDB(locations: locations)
        
        isMoving = false
    }
    
    func writeLocationToDB(locations: [CLLocation]) {
//        let context = self.context as? AKICurrentPositionContext
//        context?.locations = locations
        
    }
    
    //MARK: Observ
    
    private func initLeftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: self.logoutButtonText,
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(logout))
        
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        self.navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isRunning.value = !(self?.isRunning.value)!
                self?.logout()
            })
            .addDisposableTo(self.disposeBag)
    }
    
    func logout() {
        FBSDKLoginManager().logOut()
        try! FIRAuth.auth()?.signOut()

        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func locationObserver(_ context: AKICurrentPositionContext) -> Observable<AnyObject> {
        return context.currentPositionContext()
    }
}
