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
        let model = self.model as? AKIUser
        
        if model == nil {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: (model?.email!)!, password: (model?.password!)!) { (user, error) in
            if error != nil {
                //                self.presentAlertErrorMessage((error?.localizedDescription)!, style: .alert)
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            print(kAKISuccessfullySignUp)
            let reference = FIRDatabase.database().reference(fromURL: kAKIFirebaseURL)
            let userReference = reference.child("users").child((user?.uid)!)
            let values = ["name": model?.name, "email": model?.email, "password": model?.password]
            userReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
                if error != nil {
                    print(error?.localizedDescription ?? "default warning")
                    return
                }
                
                print("SAVED")
            })
        }
    }
}
