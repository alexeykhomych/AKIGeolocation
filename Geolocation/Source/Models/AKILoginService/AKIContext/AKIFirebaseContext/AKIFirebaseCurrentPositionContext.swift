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
            
            DispatchQueue.global().async {
                
                // MARK: need to refactor
                
                let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
                let userReference = reference.child(Context.Request.coordinates).child(self.userModel.id)
                
                let values = [Context.Request.latitude: self.latitude as Any,
                              Context.Request.longitude: self.logitude as Any] as [String : Any]
                
                userReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        observer.onNext(.failure(.description(error.localizedDescription)))
                        return
                    }
                })
                
                observer.onCompleted()
            }
                
            return Disposables.create()
        }
    }
}
