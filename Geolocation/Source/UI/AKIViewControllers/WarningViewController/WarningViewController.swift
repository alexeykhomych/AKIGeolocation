//
//  WarningViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 4/10/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit
import IDPRootViewGettable
import RxSwift
import RxCocoa

class WarningViewController: UIViewController, RootViewGettable {
    
    typealias RootViewType = WarningView

    //MARK: - Accessors
    
    private let disposeBag = DisposeBag()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    
    //MARK: - Private Methods
    
    private func prepareView() {
        self.rootView?.preferencesButton?.rx.tap
            .bindNext { [weak self] in
                self?.openAppPreferences()
            }
            .disposed(by: disposeBag)
        
        self.leftBarButtonItem()
    }
 
    private func openAppPreferences() {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    private func leftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: "Back",
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(showMainViewController))
        
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        self.navigationItem.leftBarButtonItem!.rx.tap
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .subscribe(onNext: { [unowned self] in
                self.showMainViewController()
            }).addDisposableTo(self.disposeBag)
    }
    
    @objc private func showMainViewController() {
        UIApplication.shared.delegate.map { (localApp) -> Void in
            localApp.window??.rootViewController = UINavigationController(rootViewController: AKILoginViewController())
        }
    }
}
