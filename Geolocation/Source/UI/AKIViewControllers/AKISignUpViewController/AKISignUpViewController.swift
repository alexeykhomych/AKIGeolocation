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
        self.loginService = AKILoginService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initSignUpButton() {
        guard let signUpView = self.signUpView else {
            return
        }
        
        var userModel: AKIUser?
        
        _ = signUpView.signUpButton?.rx.tap
            .map { _ in
                let tupleResult = signUpView.fillModel()
                tupleResult.1 ? userModel = tupleResult.0 : self.presentAlertErrorMessage("Your email or password is incorrect", style: .alert)

                return tupleResult.1
            }
            .filter {
                $0 == true
            }
            .flatMap { _ in
                AKILoginService().signup(with: userModel)
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
