//
//  AKISignUpView.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class AKISignUpView: UIView {
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer?
    
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    @IBOutlet var signUpButton: UIButton?
        
    let disposeBag = DisposeBag()
    
    func validateFields(userModel: AKIUser?) -> Bool {
        guard let userModel = userModel else { return false }
        return userModel.emailValidation(self.emailTextField?.text) &&
            userModel.passwordValidation(self.passwordTextField?.text) &&
            userModel.nameValidation(self.nameTextField?.text)
    }
}
