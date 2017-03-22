//
//  AKILocationViewController.swift
//  Geolocation
//
//  Created by Alexey Khomych on 2/2/17.
//  Copyright © 2017 Alexey Khomych. All rights reserved.
//

import UIKit

import GoogleMaps

import FBSDKLoginKit

import Firebase
import FirebaseAuth

import RxSwift
import RxCocoa

protocol AKILocationViewControllerProtocol {
    func subscribeCurrentPositionContext(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees)
    func observForMoving()
    func logOut()
}

class AKILocationViewController: UIViewController, AKILocationViewControllerProtocol {
    
    // MARK: Accessors
    
    var userModel: AKIUser?
    
    private var timer: Disposable?
    
    private let disposeBag = DisposeBag()
    
    private var locationManager: AKILocationManager?
    
    private let logoutButtonText = "Log out"
    
    private var locationView: AKILocationView? {
        return self.getView()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftBarButtonItem()
        self.initLocationManager()
        self.initMapView()
        self.observForMoving()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initLocationManager() {
        self.locationManager = AKILocationManager()
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
        let mapView = self.locationView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    // MARK: AKILocationViewControllerProtocol
    
    func subscribeCurrentPositionContext(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        guard let userModel = self.userModel else {
            return
        }
        
        _ = AKICurrentPositionContext(userModel, latitude: latitude, longitude: longitude).execute()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }).disposed(by: self.disposeBag)
    }
    
    func observForMoving() {
        _ = self.locationManager?
            .replaySubject?
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] locations in
                self?.locationView?.cameraPosition(locations: locations)
                }, onError: { [weak self] error in
                    self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            }).addDisposableTo(self.disposeBag)
    }
    
    func logOut() {
        _ = AKILoginService().logout(service: LoginServiceType.Firebase)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .subscribe( onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
        
        _ = AKILoginService().logout(service: LoginServiceType.Facebook)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global(qos: .background)))
            .subscribe(onError: { [weak self] error in
                self?.presentAlertErrorMessage(error.localizedDescription, style: .alert)
            })
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
