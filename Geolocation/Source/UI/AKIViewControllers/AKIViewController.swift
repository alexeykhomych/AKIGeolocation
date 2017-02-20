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

extension presentErrorMessage where Self: UIViewController {
    func presentAlertErrorMessage(_ message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: kAKIAllertTitleError, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: kAKIAllertTitleOk, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

protocol presentErrorMessage {
    func presentAlertErrorMessage(_ message: String, style: UIAlertControllerStyle)
}

protocol validateStringWithPredicate {
    func validateStringWithPredicate(_ string: String, predicate: NSPredicate) -> Bool
}

extension validateStringWithPredicate {
    func validateStringWithPredicate(_ string: String, predicate: NSPredicate) -> Bool {
        return predicate.evaluate(with: string)
    }
}

protocol validateString {
    func validateString(_ string: String)
}

class AKIViewController: UIViewController, presentErrorMessage, validateStringWithPredicate {
    
    static var observer: PublishSubject<AKIContext>?
    
    let disposeBag = DisposeBag()
    var context: AKIContext?
    
    var model: AKIModel? = nil
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func observerContext(_ context: AKIContext, observer: Observable<AnyObject>) {
        _ = observer.subscribe(onNext: { _ in
            
        },onError: { error in
            DispatchQueue.main.async {
                self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }
        },onCompleted: { result in
            DispatchQueue.main.async {
                self.contextDidLoad(context)
            }
        },onDisposed: nil)
    }
    
    func contextDidLoad(_ context: AKIContext) {
        
    }
    
    func contextDidFailLoading(_ context: AKIContext) {
        
    }
    
    func contextWillLoading(_ context: AKIContext) {
        
    }
    
    func pushViewController(_ viewController: AKIViewController, model: AKIModel?) {
        DispatchQueue.main.async {
            viewController.model = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
