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

import RxSwift
import RxCocoa

import Result

class AKICurrentPositionContext: AKIContextProtocol {
    
    typealias Signal = Observable<Result<AKIUser, AuthError>>
    
    //MARK: - Accessors
    
    let reference = FIRDatabase.database().reference()
    
    private var logitude: Double
    private var latitude: Double
    
    var userModel: AKIUser
    
    //MARK: - Initializations and Deallocations
    
    init(userModel: AKIUser, latitude: Double, longitude: Double) {
        self.userModel = userModel
        self.logitude = longitude
        self.latitude = latitude
    }
    
    //MARK: - Public methods
    
    func execute() -> Signal {
        return PublishSubject.create { observer in            
            let values = [Context.Request.latitude: self.latitude as Any,
                          Context.Request.longitude: self.logitude as Any] as [String : Any]
            
            _ = self.query(.currentPosition(user: self.userModel, coordinates: values), reference: self.reference)
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
