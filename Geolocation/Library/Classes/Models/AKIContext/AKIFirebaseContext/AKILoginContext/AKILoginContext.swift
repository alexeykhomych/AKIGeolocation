//
//  AKILoginContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import RxCocoa
import RxSwift

class AKILoginContext: AKIContext {
    
    var model: AKIModel
    
    required init(_ model: AKIModel) {
        self.model = model
    }
    
    func loginUser(_ model: AKIModel) -> Observable<AnyObject> {
        return Observable.create { observer in
            let model = self.model as! AKIUser
            FIRAuth.auth()?.signIn(withEmail: model.email!, password: model.password!, completion: { (user, error) in
                if error != nil {
                    observer.on(.error(error!))
                    return
                }
                
                model.id = user?.uid
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}
