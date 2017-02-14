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

class AKILocationViewController: AKIViewController, CLLocationManagerDelegate {
    
    let kAKILogout = "Logout"
    let kAKIDistanceFilter:CLLocationDistance = 50
    
    let kAKIGoogleMapsDefaultZoom: Float = 15.0
    let kAKIGoogmeMapsDefaultLatitude = 0.0
    let kAKIGoogleMapsDefaultLongitude = 0.0
    
    let locationManager = CLLocationManager()
    var camera = GMSCameraPosition()
    
    var locationView: AKILocationView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLocationManager()
        
        self.initLeftBarButtonItem()
        
        let mapView = self.locationView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLocationManager() {
        let locationManager = self.locationManager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kAKIDistanceFilter
        
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
        let location = locations.last
        let coordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!,
                                                longitude: (location?.coordinate.longitude)!)
        
        let mapView = self.locationView?.mapView
        mapView?.animate(with: GMSCameraUpdate.setTarget(coordinate, zoom: kAKIGoogleMapsDefaultZoom))
        
        self.writeLocationToDB(coordinate)
    }
    
    //MARK: Observ
    
    override func modelDidLoad() {
        DispatchQueue.main.async {
            print("coordinates saved")
        }
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
    
    func writeLocationToDB(_ coordinates: CLLocationCoordinate2D) {
        let context = AKICurrentPositionContext()
        context.coordinates = coordinates
        context.model = self.model
        self.setObserver(context)
    }

}
