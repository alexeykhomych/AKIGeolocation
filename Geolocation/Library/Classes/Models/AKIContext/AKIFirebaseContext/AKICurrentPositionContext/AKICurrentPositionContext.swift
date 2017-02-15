//
//  AKICurrentPositionContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import GoogleMaps

class AKICurrentPositionContext: AKIContext {
    
    var coordinates: CLLocationCoordinate2D?

    override func performExecute() {
        guard let model = self.model as? AKIUser else {
            return
        }
        
        let reference = FIRDatabase.database().reference(fromURL: kAKIFirebaseURL)
        let userReference = reference.child(kAKIRequestCoordinates).child(model.id!)
        let coordinates = self.coordinates
        
        let values = [kAKIRequestCoordinatesLatitude: coordinates!.latitude,
                      kAKIRequestCoordinatesLongitude: coordinates!.longitude] as [String : Any]
        
        userReference.updateChildValues(values, withCompletionBlock: self.updateCompletionBlock())
        
        self.contextCompleted()
    }
    
    func updateCompletionBlock() -> (Error?, FIRDatabaseReference) -> () {
        return { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
        }
    }
    
    func contextCompleted() {
        AKIViewController.observer?.onCompleted()
    }
}
