//
//  AKISignUpViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

class AKISignUpViewController: AKIViewController {
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }
    
    var loginView: AKILoginView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
