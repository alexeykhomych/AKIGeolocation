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
    
    var viewModel: AKIViewModel?
    
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
//        self.signUpView?.signUpButton?.rx.tap
//            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                let signUpView = self?.signUpView
//                
//                let model = AKIUser((signUpView?.emailTextField?.text)!,
//                                    password: (signUpView?.passwordTextField?.text)!,
//                                    name: (signUpView?.nameTextField?.text)!)
//    
//            })
//            .disposed(by: self.disposeBag)
    }
    
    func signUpObserver(_ context: AKISignUpContext) -> Observable<AKIUser> {
        return context.execute()
    }
}
