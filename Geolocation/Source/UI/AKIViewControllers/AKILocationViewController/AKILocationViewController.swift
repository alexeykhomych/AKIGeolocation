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

extension AKILocationViewController {
    
    func performResult(result: Result<[CLLocation], AuthError>) {
        switch result {
        case let .success(locations):
            self.rootView?.cameraPosition(locations: locations)
        case let .failure(error):
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }
    }
    
}

protocol AKILocationViewControllerProtocol {
    func subscribeCurrentPositionContext(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees)
    func observForMoving()
    func logOut()
}

class AKILocationViewController: UIViewController, AKILocationViewControllerProtocol, RootViewGettable {
    
    typealias RootViewType = AKILocationView
    
    // MARK: Accessors
    
    var loginService = AKIAuthService()
    
    var userModel: AKIUser?
    
    private var timer: Disposable?
    
    private let disposeBag = DisposeBag()
    
    private var locationManager = AKILocationManager()
    
    private let logoutButtonText = "Log out"
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftBarButtonItem()
        self.initMapView()
        self.observForMoving()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: Initializations and Deallocations
    
    func leftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: self.logoutButtonText,
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
    
    // MARK: Private methods
    
    private func initMapView() {
        let mapView = self.rootView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    // MARK: AKILocationViewControllerProtocol
    
    func subscribeCurrentPositionContext(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        guard let userModel = self.userModel else {
            return
        }
        
        _ = AKICurrentPositionContext(userModel: userModel, latitude: latitude, longitude: longitude).execute()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success: break
                case let .failure(error):
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
                }
            }).disposed(by: self.disposeBag)
    }
    
    func observForMoving() {
//        _ = self.locationManager
//            .replaySubject?
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { result in
//                self.performResult(result: result)
//            }).addDisposableTo(self.disposeBag)
    }
    
    func logOut() {
        _ = self.loginService.logout()
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
}
