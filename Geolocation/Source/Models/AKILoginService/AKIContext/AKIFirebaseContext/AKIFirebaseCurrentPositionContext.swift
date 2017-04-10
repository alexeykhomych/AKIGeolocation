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
    
    typealias User = AKIUser
    
    private var logitude: Double
    private var latitude: Double
    
    var userModel: AKIUser
    
    init(userModel: AKIUser, latitude: Double, longitude: Double) {
        self.userModel = userModel
        self.logitude = longitude
        self.latitude = latitude
    }
    
    internal func execute() -> Signal {
        return PublishSubject.create { observer in
            let values = [Context.Request.latitude: self.latitude as Any,
                          Context.Request.longitude: self.logitude as Any]
            
            self.updateChildValues(self.userModel.id, observer: observer, values: values, block: {})
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
