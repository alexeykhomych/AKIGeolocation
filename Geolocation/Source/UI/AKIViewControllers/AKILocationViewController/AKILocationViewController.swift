//
//  AKILocationViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift
import RxCocoa
import IDPRootViewGettable
import Result

class AKILocationViewController: UIViewController, RootViewGettable, ViewControllerResult {
    
    typealias RootViewType = AKILocationView
    
    // MARK: - Accessors
    
    var userModel: AKIUser?
    
    private var provider = AKIFirebaseAuthProvider.instance
    private var locationManager = AKILocationManager()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = self.locationManager
        
        if !manager.isAuthorizated() {
            self.showWarningViewController()
        } else {
            self.prepareView()
        }
    }
    
    // MARK: - Initializations and Deallocations
    
    func leftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: UI.ButtonName.logOut,
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(logOut))
        
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        self.navigationItem.leftBarButtonItem!.rx.tap
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .subscribe(onNext: { [unowned self] in
                self.logOut()
            }).addDisposableTo(self.disposeBag)
    }
    
    // MARK: - Private methods
    
    private func subscribeCurrentPositionContext(locations: [CLLocation]) {
        let last = locations.last.map {
            CLLocationCoordinate2D.init(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
        }
        
        guard let userModel = self.userModel,
            let coordinate = last else {
                return
        }
        
        _ = AKICurrentPositionContext(userModel: userModel, latitude: coordinate.latitude, longitude: coordinate.longitude).execute()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.performResult(result: result, block: { print("\($0)") })
            }).disposed(by: self.disposeBag)
    }
    
    private func observForMoving() {
        _ = self.locationManager
            .replaySubject?
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.performResult(result: result, block: {
                    self?.rootView?.cameraPosition(locations: $0)
                    self?.subscribeCurrentPositionContext(locations: $0)
                })
            }).addDisposableTo(self.disposeBag)
    }
    
    @objc private func logOut() {
        _ = self.provider.logout()
            .observeOn(MainScheduler.instance)
            .bindNext { [weak self] in
                switch $0 {
                case .success:
                    UIApplication.shared.delegate.map { (localApp) -> Void in
                        localApp.window??.rootViewController = UINavigationController(rootViewController: AKILoginViewController())
                    }
                case let .failure(error):
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }
        }
    }
    
    private func prepareView() {
        let manager = self.locationManager
        manager.timerInterval = 60
        manager.distanceFilter = kCLLocationAccuracyHundredMeters
        manager.initManager()
        
        self.leftBarButtonItem()
        self.prepareMapView()
        self.observForMoving()
    }
    
    private func prepareMapView() {
        let mapView = self.rootView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.settings.compassButton = true
        mapView?.settings.allowScrollGesturesDuringRotateOrZoom = true
        mapView?.settings.scrollGestures = true
    }
    
    private func showWarningViewController() {
        self.pushViewController(WarningViewController())
    }
}
