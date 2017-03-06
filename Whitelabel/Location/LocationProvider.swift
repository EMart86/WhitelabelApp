//
//  LocationProvider.swift
//  Whitelabel
//
//  Created by Martin Eberl on 01.03.17.
//  Copyright © 2017 Martin Eberl. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProviderDelegate: class {
    func didUpdate(authorizationStatus: CLAuthorizationStatus)
    func didUpdate(location: CLLocation)
}

final class LocationProvider: NSObject {
    private var locationManager: CLLocationManager?
    weak var delegate: LocationProviderDelegate?
    
    fileprivate(set) var lastKnownLocation: CLLocation?
    
    static var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func startLocationUpdate() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            createLocationManagerIfNotCreated()
            locationManager?.startUpdatingLocation()
        } else {
            requestLocationUpdates()
        }
    }
    
    func endLocationUpdate() {
        locationManager?.stopUpdatingLocation()
    }
    
    
    
    //MARK: - Private Methods
    
    private func requestLocationUpdates() {
        if LocationProvider.authorizationStatus == .notDetermined {
            createLocationManagerIfNotCreated()
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    private func createLocationManagerIfNotCreated() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startLocationUpdate()
        delegate?.didUpdate(authorizationStatus: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
        
        if let lastKnownLocation = lastKnownLocation {
            delegate?.didUpdate(location: lastKnownLocation)
        }
    }
}
