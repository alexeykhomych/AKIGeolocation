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
        let alertController = UIAlertController(title: UI.AllertMessage.titleError, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: UI.AllertMessage.titleOk, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

protocol presentErrorMessage {
    func presentAlertErrorMessage(_ message: String, style: UIAlertControllerStyle)
}

class AKIViewController: UIViewController, presentErrorMessage {
    
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
    
    func pushViewController(_ viewController: AKIViewController, model: AKIModel?) {
        DispatchQueue.main.async {
            viewController.model = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
