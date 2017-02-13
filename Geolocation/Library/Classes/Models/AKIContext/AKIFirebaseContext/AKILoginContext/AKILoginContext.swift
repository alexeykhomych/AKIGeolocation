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

class AKILoginContext: AKIContext {
    
    override func performExecute() {
        self.loginUser()
    }
    
    func loginUser() {
        let model = self.model as! AKIUser
        FIRAuth.auth()?.signIn(withEmail: model.email!, password: model.password!, completion: { (user, error) in
            if error != nil {
                AKIViewController.observer?.onError(error!)
                return
            }
            
            AKIViewController.observer?.onCompleted()
        })
    }
    
}
