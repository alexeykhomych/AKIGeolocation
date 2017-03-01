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

        let model = self.viewModel?.model
        
        if accessToken != nil {
            model?.id = accessToken?.userID
            
            let controller = AKILocationViewController()
            controller.viewModel = self.viewModel
            self.pushViewController(controller)
        }
    }
}

class AKILoginViewController: UIViewController, AKIFacebookLoginProtocol{
    
    deinit {
        print("test")
    }

    var viewModel: AKIViewModel?
    
    private let kAKILogoutButtonText = "Logout"
    let disposeBag = DisposeBag()
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initModel()
        
        self.loginWithAccessToken()
        
        self.loginView?.addBindsToViewModel(self.viewModel)
        
        self.initLoginButton()
        self.initSignupButton()
        self.initLoginWithFacebookButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initLoginButton() {
        self.loginView?.loginButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.subscribeToLoginContext(AKILoginContext(self?.viewModel))
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController())
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initLoginWithFacebookButton() {
        self.loginView?
            .loginWithFBButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.subscribeToLoginContext(AKIFacebookLoginContext(self?.viewModel))
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initModel() {
        self.viewModel = AKIViewModel(AKIUser())
    }
    
    private func subscribeToLoginContext(_ context: AKILoginContext?) {
        let contextSubscriber = context?.execute().observeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background))).shareReplay(1)
        
        contextSubscriber?
            .observeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .subscribe( onCompleted: { [weak self] result in
                let controller = AKILocationViewController()
                controller.viewModel = self?.viewModel
                self?.pushViewController(controller)
            }).disposed(by: self.disposeBag)
        
        contextSubscriber?
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func subscribeToLoginContext(_ context: AKIFacebookLoginContext?) {
        let contextSubscriber = context?.execute().observeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background))).shareReplay(1)
        
        contextSubscriber?
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .subscribe( onCompleted: { [weak self] result in
                let controller = AKILocationViewController()
                controller.viewModel = self?.viewModel
                self?.pushViewController(controller)
            })
            .disposed(by: self.disposeBag)
        
        contextSubscriber?
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .subscribe(onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
            .disposed(by: self.disposeBag)
    }
}
