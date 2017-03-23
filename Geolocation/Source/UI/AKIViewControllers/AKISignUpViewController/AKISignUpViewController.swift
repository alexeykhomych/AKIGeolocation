//
//  AKISignUpViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

import RxSwift
import RxCocoa

class AKISignUpViewController: UIViewController {
    
    // MARK: Accessors
    
    let disposeBag = DisposeBag()
    
    var userModel: AKIUser?
    
    var loginService = AKILoginService()
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
        self.loginService = AKILoginService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Initializations and Deallocations
    
    func initSignUpButton() {
        guard let signUpView = self.signUpView,
        var userModel = self.userModel else {
            return
        }
        
        _ = signUpView.signUpButton?.rx.tap
            .map { _ in
                userModel = signUpView.fillModel(userModel)
                
                let isValid = userModel.emailValidation() && userModel.passwordValidation()
                
                if !isValid {
                    self.presentAlertErrorMessage("Your email or password is incorrect", style: .alert)
                }
                
                return isValid
            }
            .filter {
                $0 == true
            }
            .flatMap { _ in
                self.loginService.signup(with: userModel)
            }
            .subscribe(onNext: { [weak self] userModel in
                    let controller = AKILocationViewController()
                    controller.userModel = userModel
                    self?.pushViewController(controller)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
}
