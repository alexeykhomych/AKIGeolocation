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
        let app = UIApplication.shared.delegate as? AKIAppDelegate
        
        _ = AKIFirebaseAuthProvider().userChangesListener().map { (auth, user) -> FIRUser? in
            return user
        }.subscribe(onNext: { result in
            let locationViewController = AKILocationViewController()
            locationViewController.userModel = result?.fill(userModel: AKIUser())
            app.map { (localApp) -> Void in
                localApp.window?.rootViewController = UINavigationController(rootViewController: locationViewController)
            }
        }, onError: { error in
            app.map { (localApp) -> Void in
                localApp.window?.rootViewController = UINavigationController(rootViewController: AKILoginViewController())
            }
        })
    }
}
