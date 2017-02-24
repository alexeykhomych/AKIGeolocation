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

protocol AKIFacebookLogin: FBSDKLoginButtonDelegate {
    
    func initFacebookLoginButton()
    func loginWithAccessToken()
    
}

extension AKILoginViewController: AKIFacebookLogin {
    
    internal func initFacebookLoginButton() {
        let facebookLoginButton = FBSDKLoginButton()
        facebookLoginButton.frame = (self.loginView?.loginWithFBButton?.frame)!
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = [Context.Permission.email, Context.Permission.publicProfile]

        self.view.addSubview(facebookLoginButton)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginWithAccessToken() {
        let accessToken = FBSDKAccessToken.current()

        if accessToken != nil {
//            let model = AKIUser()
//            model.id = accessToken?.userID
//            self.model = model
        }
    }
}

class AKILoginViewController: UIViewController {

    var viewModel: AKIViewModel?
    
    let kAKILogoutButtonText = "Logout"
    let disposeBag = DisposeBag()
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1
        self.initModel()
        
        //2
        
        self.loginView?.addBindsToViewModel(self.viewModel!)
        
//        self.initFacebookLoginButton()
        self.initLoginButton()
        self.initSignupButton()
        
//        self.loginWithAccessToken()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initModel() {
        self.viewModel = AKIViewModel(AKIUser())
    }
    
    private func initLoginButton() {
        self.loginView?.loginButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let context = AKILoginContext((self?.viewModel)!)
                self?.doSomething(context)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func initSignupButton() {
        self.loginView?.signUpButton?.rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.pushViewController(AKISignUpViewController(), viewModel: (self?.viewModel)!)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func doSomething(_ context: AKILoginContext) {
        let id = context.execute().asObservable().shareReplay(1)
        id.subscribe( onCompleted: { result in
            self.pushViewController(AKILocationViewController(), viewModel: self.viewModel!)
        }).disposed(by: self.disposeBag)
        
        id.subscribe(onError: { error in
            print(error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}

/*
 1) создаю вьюмодел с пустой моделью юзера
 2) привязываю поля вьюмодела к полям ui
 3) заполняя поля в ui вьюмодел их валидирует
 4) если валидация тру то включить кнопку логина
 
 5) при нажатии на логин передаю вьюмодел в контекст
 6) контекст заполняет модель
 7) контекст сообщает контроллеру о завершении
 8) контроллер открывает следующий контроллер
 
*/
