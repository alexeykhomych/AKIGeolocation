//
//  LaunchScreenViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/27/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import IDPRootViewGettable

import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

import Result

extension SplashScreenViewController {
    
    func performResult(result: Result<FIRUser, AuthError>) {
        let app = UIApplication.shared.delegate as? AKIAppDelegate
        
        switch result {
        case let .success(user):
            let locationViewController = AKILocationViewController()
            locationViewController.userModel = user.fill(userModel: AKIUser())
            app.map { (localApp) -> Void in
                localApp.window?.rootViewController = UINavigationController(rootViewController: locationViewController)
            }
        case let .failure(error):
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }
    }
    
}

class SplashScreenViewController: UIViewController {
    
    typealias RootViewType = SplashScreenView
    
    // MARK: Accessors
    
    var loginService = AKIAuthService()
    let disposeBag = DisposeBag()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNextViewController()
    }
    
    // MARK: Private methods
    
    private func showNextViewController() {        
        _ = AKIFirebaseAuthProvider().userChangesListener().map { return $0 }.subscribe(onNext: { result in
            let app = UIApplication.shared.delegate as? AKIAppDelegate
            
            switch result {
            case let .success(user):
                let locationViewController = AKILocationViewController()
                locationViewController.userModel = user.1.fill(userModel: AKIUser())
                app.map { (localApp) -> Void in
                    localApp.window?.rootViewController = UINavigationController(rootViewController: locationViewController)
                }
            case .failure:
                app.map { (localApp) -> Void in
                    localApp.window?.rootViewController = UINavigationController(rootViewController: AKILoginViewController())
                }
            }
        })
    }
}
