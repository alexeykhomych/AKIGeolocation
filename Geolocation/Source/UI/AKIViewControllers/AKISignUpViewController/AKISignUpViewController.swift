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
    
    var viewModel: AKIViewModel?
    
    var signUpView: AKISignUpView? {
        return self.getView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initSignUpButton()
        self.initModel()
        self.signUpView?.addBindsToViewModel(self.viewModel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initModel() {
        self.viewModel = AKIViewModel(AKIUser())
    }
    
    func signUpWithContext(_ context: AKISignUpContext) {
        let contextSubscriber = context.execute().shareReplay(1)
        
        contextSubscriber
            .observeOn(MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] result in
                let controller = AKILocationViewController()
                controller.viewModel = self?.viewModel
                self?.pushViewController(controller)
            }).disposed(by: self.disposeBag)
        
        contextSubscriber
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }).disposed(by: self.disposeBag)
    }
    
    private func initSignUpButton() {
        self.signUpView?.signUpButton?
            .rx.tap
            .debounce(Timer.Default.debounceOneSecond, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.signUpWithContext(AKISignUpContext(self?.viewModel))
            }).disposed(by: self.disposeBag)
    }
}
