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
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
        self.signUpView?.validateFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initSignUpButton() {
        self.signUpView?.signUpButton?.rx.tap
            .debounce(kAKIDebounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let signUpView = self.signUpView
                
                let model = AKIUser((signUpView?.emailTextField?.text)!,
                                    password: (signUpView?.passwordTextField?.text)!,
                                    name: (signUpView?.nameTextField?.text)!)
    
                let context = AKISignUpContext(model)
                self.observerContext(context, observer: self.signUpObserver(context))
            }).disposed(by: self.disposeBag)
    }
    
    override func contextDidLoad(_ context: AKIContext) {
        self.pushViewController(AKILocationViewController(), model: context.model)
    }
    
    func signUpObserver(_ context: AKISignUpContext) -> Observable<AnyObject> {
        return context.signUp()
    }
}
