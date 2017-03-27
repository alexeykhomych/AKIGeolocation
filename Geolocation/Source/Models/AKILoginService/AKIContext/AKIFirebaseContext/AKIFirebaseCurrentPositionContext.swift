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

class AKICurrentPositionContext: AKIContextProtocol {
    
    private var logitude: Double
    private var latitude: Double
    
    var userModel: AKIUser
    
    init(userModel: AKIUser, latitude: Double, longitude: Double) {
        self.userModel = userModel
        self.logitude = longitude
        self.latitude = latitude
    }
    
    internal func execute() -> Observable<AKIUser> {
        return PublishSubject<AKIUser>.create { observer in
            
            // MARK: need to refactor
            
            let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
            let userReference = reference.child(Context.Request.coordinates).child(self.userModel.id)
            
            let values = [Context.Request.latitude: self.latitude as Any,
                          Context.Request.longitude: self.logitude as Any] as [String : Any]
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let error = error {
                    observer.onError(error)
                    return
                }
            })
            
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
