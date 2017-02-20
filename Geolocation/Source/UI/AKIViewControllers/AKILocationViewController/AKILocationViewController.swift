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
    
    let kAKILogout = "Logout"
    
    let locationManager = CLLocationManager()
    
    var locationView: AKILocationView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initLocationManager()
        self.initLeftBarButtonItem()
        self.initMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        locationManager.distanceFilter = CLLocationDistance(kAKIDistanceFilter)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationView?.cameraPosition(locations: locations)
        let context = AKICurrentPositionContext(self.model!, locations: locations)
        self.observerContext(context, observer: self.locationObserver(context))
    }
    
    //MARK: Observ
    
    override func contextDidLoad(_ context: AKIContext) {
        print("coordinates saved")
    }
    
    private func initLeftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: kAKILogout,
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(logout))
        
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
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
