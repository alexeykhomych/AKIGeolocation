//
//  AKILoginView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKILoginView: UIView {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var loginWithFBButton: UIButton?
    @IBOutlet var signUpButton: UIButton?
    
    func validateFields(userModel: AKIUser?) -> Bool {
        guard let userModel = userModel else { return false }
        return userModel.emailValidation(self.emailTextField?.text) &&
            userModel.passwordValidation(self.passwordTextField?.text)
    }
    
    func fillModel() -> (AKIUser?, Bool) {
        var userModel = AKIUser()
        
        let isValid = self.validateFields(userModel: userModel)
        if isValid {
            userModel.password = self.passwordTextField?.text ?? ""
            userModel.email = self.emailTextField?.text ?? ""
        }        
        
        return (userModel, isValid)
    }
}
