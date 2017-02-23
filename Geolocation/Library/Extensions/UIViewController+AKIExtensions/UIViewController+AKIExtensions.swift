//
//  UIViewController+AKIExtensions.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/23/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias AKIModel = AnyObject

    func pushViewController(_ viewController: UIViewController, model: AKIModel) {
        DispatchQueue.main.async {
//            viewController.model = model
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func presentAlertErrorMessage(_ message: String, style: UIAlertControllerStyle) {
        let alertController = UIAlertController(title: UI.AllertMessage.titleError, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: UI.AllertMessage.titleOk, style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }
}
