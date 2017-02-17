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

class AKISignUpViewController: AKIViewController {
    
    let kAKIPredicateEmailFormat = "SELF MATCHES %@"
    let kAKIPredicatePasswordFormat = "%d >= %d"
    
    let kAKIPredicateEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let kAKIPredicateMinimalPasswordLength = 6
    
    let kAKIErrorMessageEnterYourEmail = "Enter your email"
    let kAKIErrorMessageEnterYourPassword = "Enter your password"
    let kAKIErrorMessageEnterYourName = "Enter your name"
    
    let kAKIErrorMessageEmailIncorrect = "Email is incorrect"
    let kAKIErrorMessagePasswordIncorect = "Password is incorrect"
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initSignUpButton() {
        self.signUpView?.signUpButton?.rx.tap
            .debounce(kAKIDebounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let signUpView = self.signUpView
                
                guard let email = signUpView?.emailTextField?.text else {
                    self.presentAlertErrorMessage(self.kAKIErrorMessageEnterYourEmail, style: .alert)
                    return
                }
                
                guard let password = signUpView?.passwordTextField?.text else {
                    self.presentAlertErrorMessage(self.kAKIErrorMessageEnterYourPassword, style: .alert)
                    return
                }
                
                guard let name = signUpView?.nameTextField?.text else {
                    self.presentAlertErrorMessage(self.kAKIErrorMessageEnterYourName, style: .alert)
                    return
                }
                
                if !self.validateStringWithPredicate(email, predicate: NSPredicate(format: self.kAKIPredicateEmailFormat, self.kAKIPredicateEmailRegex)) {
                    self.presentAlertErrorMessage(self.kAKIErrorMessageEmailIncorrect, style: .alert)
                    return
                }
                
                if !self.validateStringWithPredicate(password, predicate: NSPredicate(format: self.kAKIPredicatePasswordFormat,
                                                                                      password.characters.count,
                                                                                      self.kAKIPredicateMinimalPasswordLength))
                {
                    self.presentAlertErrorMessage(self.kAKIErrorMessagePasswordIncorect, style: .alert)
                    return
                }
                
                let model = AKIUser(email, password: password, name: name)
                self.model = model
                self.observeCurrentPositionContext(AKISignUpContext(self.model!))
            }).disposed(by: self.disposeBag)
    }
    
    override func contextDidLoad(_ context: AKIContext) {
        self.pushViewController(AKILocationViewController(), model: context.model)
    }
    
    func observeCurrentPositionContext(_ context: AKISignUpContext) {
        let observer = context.signUp(model!)
        _ = observer.subscribe(onNext: { _ in
            
        },onError: { error in
            DispatchQueue.main.async {
                self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }
        },onCompleted: { result in
            DispatchQueue.main.async {
                self.contextDidLoad(context)
            }
        },onDisposed: nil)
    }
}
