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

import RxSwift
import RxCocoa

class AKICurrentPositionContext: AKIContext {
    
    var coordinates: CLLocationCoordinate2D?
    var model: AKIModel
    
    required init(_ model: AKIModel) {
        self.model = model
    }
    
    init(_ model: AKIModel, coordinates: CLLocationCoordinate2D) {
        self.model = model
        self.coordinates = coordinates
    }
   
    func updateCompletionBlock() -> (Error?, FIRDatabaseReference) -> () {
        return { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
        }
    }
    
    func currentPositionContext(_ model: AKIModel) -> Observable<AnyObject> {
        return Observable.create { observer in
            let model = self.model as? AKIUser
            
            let reference = FIRDatabase.database().reference(fromURL: kAKIFirebaseURL)
            let userReference = reference.child(kAKIRequestCoordinates).child((model?.id!)!)
            let coordinates = self.coordinates
            
            let values = [kAKIRequestCoordinatesLatitude: coordinates!.latitude,
                          kAKIRequestCoordinatesLongitude: coordinates!.longitude] as [String : Any]
            
            userReference.updateChildValues(values, withCompletionBlock: self.updateCompletionBlock())
            
            observer.onNext(model!)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
