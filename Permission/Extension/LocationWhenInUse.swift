//
//  LocationWhenInUse.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import CoreLocation

private let manager = CLLocationManager()
private var requestedLocation = false
private var triggerCallbacks  = false

extension Permission: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (requestedLocation, triggerCallbacks) {
        case (true, false):
            triggerCallbacks = true
        case (true, true):
            requestedLocation = false
            triggerCallbacks  = false
            callbacks(self.status)
        default:
            break
        }
    }
}

extension CLLocationManager {
    /**
     Function to request autorization.
     - Parameters:
     - permission: an instance of 'Permission'
     */
    func request(_ permission: Permission) {
        delegate = permission
        
        requestedLocation = true
        
        if case .locationWhenInUse = permission.type {
            requestWhenInUseAuthorization()
            return
        }
    }
}

/// Permission's extension to Locations
extension Permission {
    /// Status
    var statusLocationWhenInUse: PermissionStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .disabled }
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways: return .authorized
        case .restricted, .denied:                    return .denied
        case .notDetermined:                          return .notDetermined
        default:
            fatalError()
        }
    }
    
    /**
    Regust to autorized.
    - Parameters:
    - callback: Permission's callbac 'Callback'
    */
    func requestLocationWhenInUse(_ callback: Callback) {
        manager.request(self)
    }
}
