//
//  Permission.swift
//  Livemetric
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import UIKit

/// Permissiones service.
class Permission: NSObject {
    
    /// Alias of callback to permission reguest, returns status
    typealias Callback = (PermissionStatus) -> Void
    
    /// Contact's permissions
    static let contacts          = Permission(type: .contacts)
    /// LocationWhenInUse's permissions
    static let locationWhenInUse = Permission(type: .locationWhenInUse)
    /// Microphone's permission
    static let microphone        = Permission(type: .microphone)
    /// Camera's permissions
    static let camera            = Permission(type: .camera)
    /// Photos's permissions
    static let photos            = Permission(type: .photos)
    /// Event's permissions
    static let events            = Permission(type: .events)
    /// Media library's permissions
    static let mediaLibrary      = Permission(type: .mediaLibrary)
    /// Bluetooth's permissions
    static let bluetooth         = Permission(type: .bluetooth)
    /// Motion's permissions
    static let motion            = Permission(type: .motion)
    /// Notification's permissions
    static let notification      = Permission(type: .notification)
    
    /// Permission's type
    let type: PermissionType
    
    /// Permission's status.
    var status: PermissionStatus {
        if case .contacts          = type { return statusContacts }
        if case .locationWhenInUse = type { return statusLocationWhenInUse }
        if case .microphone        = type { return statusMicrophone }
        if case .camera            = type { return statusCamera }
        if case .photos            = type { return statusPhotos }
        if case .events            = type { return statusEvents }
        if case .mediaLibrary      = type { return statusMediaLibrary }
        if case .bluetooth         = type { return statusBluetooth }
        if case .motion            = type { return statusMotion }
        if case .notification      = type { return statusNotification }
        fatalError()
    }
    
    /// Flag to show permission's alert, default is 'false'
    var presentPrePermissionAlert = false
    /// Permission's alert
    lazy var prePermissionAlert: PermissionAlert = {
        return PrePermissionAlert(permission: self)
    }()
    
    /// Flag to show denied alert, default value is 'true'
    var presentDeniedAlert = true
    /// Denied alert
    lazy var deniedAlert: PermissionAlert = {
        return DeniedAlert(permission: self)
    }()
   
    /// Flag to show disable alert, default value is 'true'.
    var presentDisabledAlert = true
    /// Disable alert
    lazy var disabledAlert: PermissionAlert = {
        return DisabledAlert(permission: self)
    }()
    
    /// Callaback
    var callback: Callback?
    
    private init(type: PermissionType) {
        self.type = type
    }
    
    /**
     Function does reguest to permission.
     - NOTE: function check current status and call request to current status.
     - Parameters:
     - callback: 'Callback' response callback, returns status.
     */
    func request(_ callback: @escaping Callback) {
        self.callback = callback
        switch status {
        case .authorized:    callbacks(status)
        case .notDetermined: presentPrePermissionAlert ? prePermissionAlert.present() : requestAuthorization(callbacks)
        case .denied:        presentDeniedAlert ? deniedAlert.present() : callbacks(status)
        case .disabled:      presentDisabledAlert ? disabledAlert.present() : callbacks(status)
        }
    }
    
    /**
     Function does request to autorization.
     - Function does request to authorization.
     - Parameters:
     - callback: 'Callback' response callback, returns status.
     */
    func requestAuthorization(_ callback: @escaping Callback) {
        if case .contacts = type {
            requestContacts(callback)
            return
        }
        if case .locationWhenInUse = type {
            requestLocationWhenInUse(callback)
            return
        }
        if case .microphone = type {
            requestMicrophone(callback)
            return
        }
        if case .camera = type {
            requestCamera(callback)
            return
        }
        if case .photos = type {
            requestPhotos(callback)
            return
        }
        if case .events = type {
            requestEvents(callback)
            return
        }
        if case .mediaLibrary = type {
            requestMediaLibrary(callback)
            return
        }
        if case .bluetooth = type {
            requestBluetooth(callback)
            return
        }
        if case .motion = type { 
            requestMotion(callback)
            return
        }
        if case .notification = type {
            requestNotification(callback)
            return
        }
        fatalError()
    }
    
    /**
     Calls callback in main thread.
     - Parameters:
     - with: Status
     */
    func callbacks(_ with: PermissionStatus) {
        DispatchQueue.main.async {
            self.callback?(self.status)
        }
    }
    
}

extension Permission {
    override var description: String {
        return type.description
    }
    override var debugDescription: String {
        return "\(type): \(status)"
    }
}
