//
//  AKIViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class AKIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pushToViewController(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentAlertErrorMessage(_ message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: kAKIAllertTitleError, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: kAKIAllertTitleOk, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validateFields(_ email: String, password: String) -> Bool {        
        if !email.isEmpty || !password.isEmpty {
            return true
        } else {
            self.presentAlertErrorMessage("Input your email and password", style: .alert)
            return false
        }
    }

}
