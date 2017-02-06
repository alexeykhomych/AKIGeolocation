//
//  AKILocationViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

class AKILocationViewController: AKIViewController, CLLocationManagerDelegate {
    
    let kAKILogout = "Logout"
    
    let kAKIGoogleMapsDefaultZoom: Float = 15.0
    let kAKIGoogmeMapsDefaultLatitude = -33.86
    let kAKIGoogleMapsDefaultLongitude = 151.20
    
    var previousLatitude: CLLocationDegrees?
    var previousLongitude: CLLocationDegrees?
    
    let locationManager = CLLocationManager()
    var mapView: GMSMapView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addGoogleMapToViewController()
        let camera = GMSCameraPosition.camera(withLatitude: kAKIGoogmeMapsDefaultLatitude,
                                              longitude: kAKIGoogleMapsDefaultLongitude,
                                              zoom: Float(kAKIGoogleMapsDefaultZoom))
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        self.currentLocation()
        self.mapView = mapView
        
        self.initRightBarButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addGoogleMapToViewController() {
        let camera = GMSCameraPosition.camera(withLatitude: kAKIGoogmeMapsDefaultLatitude,
                                              longitude: kAKIGoogleMapsDefaultLongitude,
                                              zoom: Float(kAKIGoogleMapsDefaultZoom))
        
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView

        self.mapView = mapView
    }
    
    func currentLocation() {
        let locationManager = self.locationManager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: kAKIGoogleMapsDefaultZoom)
        self.mapView?.animate(to: camera)
//        self.locationManager.stopUpdatingLocation()
    }
    
    override func modelDidLoad() {
        DispatchQueue.main.async {
            
        }
    }
    
    private func initRightBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: kAKILogout,
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(logout))
        
        self.navigationItem.setRightBarButton(logoutButton, animated: true)
    }
    
    func logout() {
        let context = AKILogOutContext()
        context.model = self.model
        context.execute()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
