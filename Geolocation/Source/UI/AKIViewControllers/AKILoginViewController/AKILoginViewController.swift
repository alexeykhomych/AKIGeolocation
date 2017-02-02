//
//  AKILoginViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKLoginKit

class AKILoginViewController: UIViewController {
    
    var model: AnyObject?
    
    func getView<R>() -> R? {
        return self.viewIfLoaded.flatMap { $0 as? R }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let facebookLoginButton = FBSDKLoginButton.init()
        facebookLoginButton.center = self.view.center
        self.view.addSubview(facebookLoginButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginFBButton(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
    }

}
