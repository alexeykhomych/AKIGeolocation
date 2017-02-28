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

extension AKILocationViewController {
    
    func logOut() {
        FBSDKLoginManager().logOut()
        try! FIRAuth.auth()?.signOut()
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

class AKILocationViewController: UIViewController {
    
    var viewModel: AKIViewModel?
    
    var isMoving: Bool = false
    let disposeBag = DisposeBag()
    
    var locationManager: AKILocationManager?
    let isRunning = Variable(true)
    
    let logoutButtonText = "Log out"
    
    var locationView: AKILocationView? {
        return self.getView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initLeftBarButtonItem()
        self.initTimer()
        self.initLocationManager()
        self.initMapView()
        self.observForMoving()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initMapView() {
        let mapView = self.locationView?.mapView
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
    }
    
    func initLocationManager() {
        self.locationManager = AKILocationManager()
    }
    
    func initTimer() {
        self.isRunning.asObservable()
            .flatMapLatest {  isRunning in
                isRunning ? Observable<Int>.interval(RxTimeInterval(Timer.Default.timerInterval),
                                                     scheduler: MainScheduler.instance) : .empty()
            }
            .flatMapWithIndex { (int, index) in Observable.just(index) }
            .subscribe(onNext: { [weak self] _ in
                
            })
            .addDisposableTo(self.disposeBag)
    }
    
    func writeLocationToDB(_ longitude: CLLocationDegrees, latitude: CLLocationDegrees) {
        let context = AKICurrentPositionContext(self.viewModel!, latitude: latitude, longitude: longitude)
        let id = context.execute()
            .asObservable()
            
        
        id.subscribe( onCompleted: { result in
            print("хуйня записана в бд")
        }).disposed(by: self.disposeBag)
        
        id.subscribe(onError: { error in
            self.presentAlertErrorMessage(error.localizedDescription, style: .alert)
        }).disposed(by: self.disposeBag)

    }
    
    private func initLeftBarButtonItem() {
        let logoutButton = UIBarButtonItem.init(title: self.logoutButtonText,
                                                style: UIBarButtonItemStyle.plain,
                                                target: self,
                                                action: #selector(logOut))
        
        self.navigationItem.setLeftBarButton(logoutButton, animated: true)
        self.navigationItem.leftBarButtonItem!.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isRunning.value = !(self?.isRunning.value)!
                self?.logOut()
            })
            .addDisposableTo(self.disposeBag)
    }
    
    private func observForMoving() {
        _ = self.locationManager?.replaySubject.subscribe(onNext: { locations in
            DispatchQueue.main.async {
                self.locationView?.cameraPosition(locations: locations)
            }
        }).addDisposableTo(self.disposeBag)
    }
}
