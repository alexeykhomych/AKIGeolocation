//
//  AKISignUpContext.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class AKISignUpContext: AKIContext {
    
    override func performExecute() {
        guard let model = self.model as? AKIUser else {
            return
        }

        FIRAuth.auth()?.createUser(withEmail: model.email!, password: model.password!, completion: self.createUserCompletionHandler())
    }
    
    func createUserCompletionHandler() -> (FIRUser?, Error?) -> () {
        return { (user, error) in
            if error != nil {
//                self.presentAlertErrorMessage((error?.localizedDescription)!, style: .alert)
            }
            
            let model = self.model as? AKIUser
//            model?.id = user?.uid
            
            let reference = FIRDatabase.database().reference(fromURL: kAKIFirebaseURL)
            let userReference = reference.child(kAKIRequestUsers).child(kAKIRequestUsers)
            let values = [kAKIRequestName: model?.name, kAKIRequestEmail: model?.email, kAKIRequestPassword: model?.password]
            userReference.updateChildValues(values, withCompletionBlock: self.updateCompletionBlock())
            
            self.contextCompleted()
        }
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
