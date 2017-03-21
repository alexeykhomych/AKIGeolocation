//
//  AKILoginService.swift
//  Geolocation
//
//  Created by Alexey Khomych on 3/6/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

enum LoginServiceType {
    case Facebook
    case Firebase
    case FacebookToken
    case FirebaseToken
}

class AKILoginService {
    
    private let disposeBag = DisposeBag()
    
    // MARK: Public methods
    
    func login(with userModel: AKIUser?, service: LoginServiceType) -> Observable<AKIUser> {
        switch service {
            case .Facebook:
            return self.loginProcess()
//                return AKIFacebookLoginProvider().login()
            case .Firebase:
                return AKIFirebaseLoginProvider().login(with: userModel)
            case .FacebookToken:
                return AKIFacebookLoginProvider().loginWithAccessToken()
            case .FirebaseToken:
                return AKIFirebaseLoginProvider().login(with: AKIFacebookLoginProvider().accessToken?.tokenString)
//            return self.loginProcess()
        }
    }
    
    func logout(service: LoginServiceType) -> Observable<AKIUser> {
        switch service {
            case .Facebook:
                return AKIFacebookLoginProvider().logout()
            case .Firebase:
                return AKIFirebaseLoginProvider().logout()
            default:
                return Observable<AKIUser>.empty()
        }
    }
    
    func signup(with userModel: AKIUser?) -> Observable<AKIUser> {
        return AKIFirebaseLoginProvider().signup(with: userModel)
    }
    
    // MARK: Private methods
    
    private func loginProcess() -> Observable<AKIUser> {
        var signal = AKIFacebookLoginProvider().login().subscribe(onNext: { _ in
            AKIFirebaseLoginProvider().login(with: AKIFacebookLoginProvider().accessToken?.tokenString)
        }).addDisposableTo(self.disposeBag)
        
        return signal
    }
}
