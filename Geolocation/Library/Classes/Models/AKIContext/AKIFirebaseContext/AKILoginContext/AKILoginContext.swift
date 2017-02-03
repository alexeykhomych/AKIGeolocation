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
        
    }
    
    func loginUser(_ login: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: login, password: password, completion: { (user, error) in
            if error == nil {
//                let controller = AKILocationViewController()
//                self.navigationController?.pushViewController(controller, animated: true)
            } else {
//                let alertController = UIAlertController(title: kAKIAllertTitleError, message: kAKIAllertMessage, preferredStyle: .alert)
                
//                alertController.addAction(UIAlertAction(title: kAKIAllertTitleError, style: .cancel, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
}
