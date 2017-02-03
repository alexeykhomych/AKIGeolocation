//
//  AKIAppDelegate.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import FBSDKCoreKit

import Firebase

import GoogleMaps

@UIApplicationMain
class AKIAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window;
        
        let navigationController = UINavigationController(rootViewController: AKILoginViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        FIRApp.configure()
        
        GMSServices.provideAPIKey(kAKIGoogleAPIKey)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

