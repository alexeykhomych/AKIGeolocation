//
//  AKILocationView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

class AKILocationView: UIView {
    @IBOutlet var mapView: GMSMapView?
    
    func cameraPosition(locations: [CLLocation]) {
        let coordinate = locations.last.map {
            return CLLocationCoordinate2D.init(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
        }
    
        self.mapView?.animate(with: GMSCameraUpdate.setTarget(coordinate!, zoom: Google.Maps.Default.zoom))
    }
}
