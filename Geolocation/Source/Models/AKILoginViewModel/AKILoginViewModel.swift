//
//  AKILoginViewModel.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/21/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class AKILoginViewModel {
    private let loginContext: AKILoginContext
    private let disposeBag = DisposeBag()
    
    private let user: Observable<AKIUser>
    
    let name: Observable<String>
    let password: Observable<String>
    let email: Observable<String>
    let id: Observable<String>
    
    init(_ loginContext: AKILoginContext) {
        
        let user = loginContext.loginUser().asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .shareReplay(1)
        
        self.user = user 
        
        self.name = user.map { $0.name ?? "" }
        self.password = user.map { $0.password ?? "" }
        self.email = user.map { $0.email ?? "" }
        self.id = user.map { $0.id ?? "" }
        
        self.loginContext = loginContext
    }
}
