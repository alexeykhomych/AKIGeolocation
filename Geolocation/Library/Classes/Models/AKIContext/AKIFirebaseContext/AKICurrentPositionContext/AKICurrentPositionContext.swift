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
    
    private var logitude: Double?
    private var latitude: Double?
    
    var userModel: AKIUser?
    
    required init(_ userModel: AKIUser?) {
        self.userModel = userModel
    }
    
    init(_ userModel: AKIUser?, latitude: Double?, longitude: Double?) {
        self.userModel = userModel
        self.logitude = longitude
        self.latitude = latitude
    }
    
    func updateCompletionBlock() -> (Error?, FIRDatabaseReference) -> () {
        return { (error, reference) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
        }
    }
    
    internal func execute() -> Observable<AKIUser> {
        let observer = PublishSubject<AKIUser>()
        _ = observer.subscribe({ observer in

            guard let user = self.userModel else {
                return
            }
            
            guard let id = user.id else {
                return
            }
            
            let reference = FIRDatabase.database().reference(fromURL: Context.Request.fireBaseURL)
            let userReference = reference.child(Context.Request.coordinates).child(id)
            
            let values = [Context.Request.latitude: self.latitude as Any,
                          Context.Request.longitude: self.logitude as Any] as [String : Any]
            
            userReference.updateChildValues(values, withCompletionBlock: self.updateCompletionBlock())
        })
        
        observer.onCompleted()
        
        return observer
    }
}
