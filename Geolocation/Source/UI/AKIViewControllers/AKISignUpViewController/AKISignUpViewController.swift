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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initSignUpButton() {
        self.signUpView?.signUpButton?.rx.tap
            .debounce(kAKIDebounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let signUpView = self.signUpView
                if !(signUpView?.validateFields())! {
                    self.presentAlertErrorMessage("Data is not valide", style: .alert)
                    return
                }
                
                let model = AKIUser((signUpView?.emailTextField?.text)!,
                                    password: (signUpView?.passwordTextField?.text)!,
                                    name: (signUpView?.nameTextField?.text)!)
                
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
