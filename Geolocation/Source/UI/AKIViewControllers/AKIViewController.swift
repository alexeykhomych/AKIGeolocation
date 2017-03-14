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

extension Tappable where Self: UIViewController {
    func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

protocol Tappable {
    func tapGestureRecognizer(sender: UITapGestureRecognizer)
}

protocol AKIViewController {
    var model: AKIUser? { get set }
}
