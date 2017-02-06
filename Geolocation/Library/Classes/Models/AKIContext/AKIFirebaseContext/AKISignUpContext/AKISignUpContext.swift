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
    
    func performExecute() {
        if model == nil {
            return
        }
        
        let model = self.model as? AKIUser
        
        FIRAuth.auth()?.createUser(withEmail: model.email!, password: model.password!) { (user, error) in
            if error == nil {
                print(self.kAKISuccessfullySignUp)
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.presentAlertErrorMessage((error?.localizedDescription)!, style: .alert)
            }
        }
    }
}
