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

protocol AKIFacebookLoginProtocol {
    func loginWithAccessToken()
}

protocol AKIFacebookLogOutProtocol {
    func logOutWithFacebook()
}

extension AKILoginViewController {
    
    func loginWithAccessToken() {
        let accessToken = FBSDKAccessToken.current()

        let model = AKIUser()
        self.viewModel?.model = model
        
        if accessToken != nil {
            model.id = accessToken?.userID
            self.viewModel?.model = model
            let controller = AKILocationViewController()
            controller.viewModel = self.viewModel
            self.pushViewController(controller)
        }
    }
    
    func initLoginButton() {
        self.loginView?.loginButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let controller = AKILocationViewController()
                controller.viewModel = self?.viewModel
                self?.pushViewController(controller)
            })
            .disposed(by: self.disposeBag)
    }
    
    func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController())
            })
            .disposed(by: self.disposeBag)
    }
    
    func initLoginWithFacebookButton() {
        self.loginView?.loginWithFBButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let controller = AKILocationViewController()
                controller.viewModel = self?.viewModel
                self?.pushViewController(controller)
            })
            .disposed(by: self.disposeBag)
    }
}

class AKILoginViewController: UIViewController, AKIFacebookLoginProtocol{

    var viewModel: AKIViewModel?
    
    private let kAKILogoutButtonText = "Logout"
    let disposeBag = DisposeBag()
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initModel()
        
        self.loginView?.addBindsToViewModel(self.viewModel!)
        
        self.initLoginButton()
        self.initSignupButton()
        self.initLoginWithFacebookButton()
        self.loginWithAccessToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initModel() {
        self.viewModel = AKIViewModel(AKIUser())
    }
    
    private func subscribeToLoginContext(_ context: AKILoginContext) {
        let id = context.execute().asObservable().shareReplay(1)
        
        id.subscribe( onCompleted: { result in
            self.pushViewController(AKILocationViewController())
        }).disposed(by: self.disposeBag)
        
        id.subscribe(onError: { error in
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }).disposed(by: self.disposeBag)
    }
    
    private func subscribeToLoginContext(_ context: AKIFacebookLoginContext) {
        let id = context.execute().asObservable().shareReplay(1)
        
        id.subscribe( onCompleted: { result in
            self.pushViewController(AKILocationViewController())
        }).disposed(by: self.disposeBag)
        
        id.subscribe(onError: { error in
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }).disposed(by: self.disposeBag)
    }
}
