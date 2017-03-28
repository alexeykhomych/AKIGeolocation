//
//  LaunchScreenViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/27/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import SystemConfiguration

import RxSwift
import RxCocoa

import Firebase
import FirebaseAuth

class SplashScreenViewController: UIViewController {
    
    // MARK: Accessors
    
    var loginService = AKIAuthService()
    let disposeBag = DisposeBag()
    
    func magick() {
        if !self.isInternetAvailable() {
            self.presentAlertErrorMessage(AKIError.internetConnection, style: .alert)
            self.show(AKILoginViewController(), sender: nil)
        }
        
        self.loginWithCurrentUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNextViewController()
    }
    
    
    // MARK: Public methods
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // MARK: Private methods
    
    private func showNextViewController() {
        let loginViewController = AKILoginViewController()
        
        let navigationViewController = UINavigationController(rootViewController: loginViewController)
        UIApplication.shared.windows.first?.rootViewController = loginViewController
        
        
        _ = AKIFirebaseAuthProvider().userChangesListener().map { (auth, user) -> FIRUser? in
            return user
            }.subscribe(onNext: { [weak self] result in
                let locationViewController = AKILocationViewController()
                let user = AKIUser()
                locationViewController.userModel = result?.fill(userModel: user)
                navigationViewController.pushViewController(locationViewController, animated: true)
//                self?.present(navigationViewController, animated:true, completion: nil)
                }, onError: { [weak self] error in
//                navigationViewController.pushViewController(loginViewController, animated: false)
//                    self?.present(loginViewController, animated:true, completion: nil)
                    navigationViewController.show(loginViewController, sender: nil)
            })
    }
    
    private func loginWithCurrentUser() {
        let viewController = AKILoginViewController()
        let userModel = AKIUser()
            
        
        _ = self.loginService.login(with: userModel, service: .facebook, viewController: viewController)
            .subscribe(onNext: { [weak self] user in
                    let locationViewController = AKILocationViewController()
                    locationViewController.userModel = user
                    self?.navigationController?.pushViewController(locationViewController)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
                })
            .disposed(by: self.disposeBag)
    }
}
