//
//  AKIViewController.swift
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

class AKIViewController: UIViewController {
    
    static var observer: PublishSubject<AKIContext>?
    
    let disposeBag = DisposeBag()
    var context: AKIContext?
    
    var model: AnyObject? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func pushToViewController(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func presentAlertErrorMessage(_ message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: kAKIAllertTitleError, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: kAKIAllertTitleOk, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validateFields(_ email: String, password: String) -> Bool {        
        if !email.isEmpty || !password.isEmpty {
            return true
        } else {
            self.presentAlertErrorMessage("Input your email and password", style: .alert)
            return false
        }
    }
    
    func setObserver(_ context: AKIContext) {
        AKIViewController.observer = PublishSubject<AKIContext>()
        AKIViewController.observer?.subscribe(onNext: { context in
            self.modelWillLoading()
            context.execute()
        }, onError: { error in
            self.presentAlertErrorMessage(context.errorMessage!, style: .alert)
            self.modelDidFailLoading()
        }, onCompleted: {
            self.modelDidLoad()
        }, onDisposed: {
            
        }).addDisposableTo(self.disposeBag)
        
        AKIViewController.observer?.onNext(context)
    }
    
    func modelDidLoad() {
        
    }
    
    func modelDidFailLoading() {
        
    }
    
    func modelWillLoading() {
        
    }

}
