//
//  AKIViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit
import Result

extension ViewControllerResult where Self: UIViewController {
    func performResult<R, E>(result: Result<R, E>, block: ((R) -> ())) {
        switch result {
        case let .success(user):
            block(user)
        case let .failure(error):
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }
    }
}

protocol ViewControllerResult {
    func performResult<R>(result: Result<R, AuthError>, block: ((R) -> ()))
}
