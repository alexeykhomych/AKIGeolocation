//
//  AKILoginViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import FBSDKLoginKit

class AKILoginViewController: UIViewController, Tappable, contextObserver {
    var viewModel: AKIViewModel?
    
    private let kAKILogoutButtonText = "Logout"
    let disposeBag = DisposeBag()
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initModel()
        
//        _ = self.loginWithAccessToken()
        
        self.loginView?.addBindsToViewModel(self.viewModel)
        
        self.initLoginButton()
        self.initSignupButton()
        self.initLoginWithFacebookButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initLoginButton() {
        _ = self.loginView?.loginButton?.rx.tap
            .flatMap( { result in
                return Observable.from(AKILoginContext(self.viewModel).execute())
            })
            .subscribe(onNext: { [weak self] result in
                self?.showLocationViewControllerWithViewModel(self?.viewModel)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initLoginWithFacebookButton() {
        self.loginView?.loginWithFBButton?.rx.tap
            .flatMap( { result in
                return Observable.from(AKIFacebookLoginContext(self.viewModel).execute())
            })
            .subscribe(onNext: { [weak self] result in
                self?.showLocationViewControllerWithViewModel(self?.viewModel)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initModel() {
        self.viewModel = AKIViewModel(AKIUser())
    }
    
    func showLocationViewControllerWithViewModel(_ viewModel: AKIViewModel?) {
        let controller = AKILocationViewController()
        controller.viewModel = viewModel
        self.pushViewController(controller)
    }
    
}
