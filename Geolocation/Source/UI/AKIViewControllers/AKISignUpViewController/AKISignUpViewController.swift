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
    
    let disposeBag = DisposeBag()
    
    var userModel: AKIUser?
    
    var loginService: AKILoginService?
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
        self.initModel()
        self.loginService = AKILoginService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initModel() {
        self.userModel = AKIUser()
    }
    
    private func initSignUpButton() {
//        _ = self.signUpView?.signUpButton?.rx.tap.map{-> User}
//            .flatMap( { result in
//                return AKILoginService(user).signup()
//            })
        
        guard let userModel = self.userModel else {
            return
        }
        
        if !(self.signUpView?.validateFields(userModel: userModel))! {
            return
        }
        
        _ = self.signUpView?.signUpButton?.rx.tap
            .flatMap( { result in
                return AKILoginService().signup(with: userModel)
            })
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
