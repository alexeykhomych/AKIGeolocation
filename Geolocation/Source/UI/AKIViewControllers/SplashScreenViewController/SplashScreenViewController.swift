//
//  LaunchScreenViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/27/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Result

class SplashScreenViewController: UIViewController {
    
    // MARK: - Accessors
    
    private let loginService = AKIAuthService()
    private let disposeBag = DisposeBag()
    
    //  MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNextViewController()
    }
    
    // MARK: - Private methods
    
    private func showNextViewController() {        
        _ = AKIFirebaseAuthProvider().userChangesListener().map { return $0 }.subscribe(onNext: { result in
            let app = UIApplication.shared.delegate as? AKIAppDelegate
            
            switch result {
            case let .success(user):
                let locationViewController = AKILocationViewController()
                locationViewController.userModel = AKIUser().fill(user: user.1)
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
