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
            if error == nil {
                print(kAKISuccessfullySignUp)
            } else {
//                self.presentAlertErrorMessage((error?.localizedDescription)!, style: .alert)
            }
        }
    }
}
