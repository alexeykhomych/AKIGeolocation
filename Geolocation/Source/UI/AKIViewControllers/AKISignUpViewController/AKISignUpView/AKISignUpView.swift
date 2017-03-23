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
    
    func fillModel(_ userModel: AKIUser) -> AKIUser {
        var userModel = userModel
        userModel.password = self.passwordTextField?.text ?? ""
        userModel.email = self.emailTextField?.text ?? ""
        userModel.name = self.nameTextField?.text ?? ""
        
        return userModel
    }
}
