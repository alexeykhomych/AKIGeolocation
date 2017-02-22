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
        let location = locations.last
        let coordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!,
                                                longitude: (location?.coordinate.longitude)!)
        
        self.mapView?.animate(with: GMSCameraUpdate.setTarget(coordinate, zoom: Google.Maps.Default.zoom))
    }
}
