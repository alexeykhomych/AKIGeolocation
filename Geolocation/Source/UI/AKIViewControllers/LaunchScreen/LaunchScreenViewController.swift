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

class LaunchScreenViewController: UIViewController {
    
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
    }
    
    
    // MARK: Public methods
    
    func chooseLoginType() {
//        if !self.isInternetAvailable() {
//            self.presentAlertErrorMessage(AKIError.internetConnection, style: .alert)
//            self.pushViewController(AKILoginViewController())
//        }
//        
//        self.pushViewController(AKILoginViewController())
    }
    
    func isInternetAvailable() -> Bool
    {
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
