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
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
        self.initModel()
        self.signUpView?.addBinds(to: self.userModel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initModel() {
        self.userModel = AKIUser()
    }
    
    private func initSignUpButton() {
        _ = self.signUpView?.signUpButton?.rx.tap
            .flatMap( { result in
                return AKILoginService(self.userModel).signup()
            })
            .subscribe(onNext: { [weak self] userModel in
                let controller = AKILocationViewController()
                controller.userModel = self?.userModel
                self?.pushViewController(controller)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
}
