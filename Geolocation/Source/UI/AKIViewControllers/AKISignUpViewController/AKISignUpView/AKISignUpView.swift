//
//  AKISignUpView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKISignUpView: UIView {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    @IBOutlet var signUpButton: UIButton?
    
    func validateFields(userModel: AKIUser?) -> Bool {
        guard let userModel = userModel else { return false }
        return userModel.emailValidation(self.emailTextField?.text) &&
            userModel.passwordValidation(self.passwordTextField?.text) &&
            userModel.nameValidation(self.nameTextField?.text)
    }
    
    func fillModel() -> (AKIUser?, Bool) {
        var userModel: AKIUser?
        
        let isValid = self.validateFields(userModel: userModel)
        if isValid {
            userModel?.password = self.passwordTextField?.text ?? ""
            userModel?.email = self.emailTextField?.text ?? ""
            userModel?.name = self.nameTextField?.text ?? ""
        }
        
        return (userModel, isValid)
    }
}
