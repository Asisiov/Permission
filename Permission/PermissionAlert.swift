//
//  PermissionAlert.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import UIKit

/// Presenter permission's alert.
class PermissionAlert {
    /// Current permission model
    let permission: Permission
    
    /// Current status of permission
    var status: PermissionStatus { return permission.status }
    /// Type of current permission
    var type: PermissionType { return permission.type }
    /// Permission's callback
    var callbacks: Permission.Callback { return permission.callbacks }
    
    /// Title to alert
    var title: String?
    /// Message to alert
    var message: String?
    
    /// Cancel action title
    var cancel: String? {
        get { return cancelActionTitle }
        set { cancelActionTitle = newValue }
    }
    
    /// Settings action title
    var settings: String? {
        get { return defaultActionTitle }
        set { defaultActionTitle = newValue }
    }
    
    /// Confirm action title
    var confirm: String? {
        get { return defaultActionTitle }
        set { defaultActionTitle = newValue }
    }
    
    /// Cancel action title
    var cancelActionTitle: String?
    /// Default action alert
    var defaultActionTitle: String?
    
    /// Permission's alert controller
    var alert: UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelActionTitle, style: .cancel, handler: cancelHandler))
        return alert
    }
    
    /**
     Init permission alert
     - Parameters:
     - permission: an instance of permission to alert.
     */
    init(permission: Permission) {
        self.permission = permission
    }
    
    /// Presents alert
    func present() {
        DispatchQueue.main.async {
            if let controller = UIApplication.topViewController() {
                controller.present(self.alert, animated: true)
            }
        }
    }
    
    private func cancelHandler(_ action: UIAlertAction) {
        callbacks(status)
    }
}

/// Disable permission alert
class DisabledAlert: PermissionAlert {
    /**
     Init disable alert.
     - Parameters:
     - permission: an instance of permission to disable.
     */
    override init(permission: Permission) {
        super.init(permission: permission)
        title   = "\(permission) is currently disabled"
        message = "Please enable access to \(permission) in the Settings app."
        cancel  = "OK"
    }
}

/// Denied permission alert
class DeniedAlert: PermissionAlert {
    /// Denied alert controller.
    override var alert: UIAlertController {
        let alert = super.alert
        let action = UIAlertAction(title: defaultActionTitle, style: .default, handler: settings)
        alert.addAction(action)
        alert.preferredAction = action
        return alert
    }
    
    /**
    Init denied alert.
    - Parameters:
    - permission: an instance of permission to denied.
    */
    override init(permission: Permission) {
        super.init(permission: permission)
        title    = "Permission for \(permission) was denied"
        message  = "Please enable access to \(permission) in the Settings app."
        cancel   = "Cancel"
        settings = "Settings"
    }
    
    /// Calls permission's callback.
    @objc func settingsHandler() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        callbacks(status)
    }
    
    private func settings(_ action: UIAlertAction) {
        NotificationCenter.default.addObserver(self, selector: #selector(settingsHandler), name: UIApplication.didBecomeActiveNotification, object: nil)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

/// Pre permission's alert
class PrePermissionAlert: PermissionAlert {
    /// Pre alert controller.
    override var alert: UIAlertController {
        let alert = super.alert
        let action = UIAlertAction(title: defaultActionTitle, style: .default, handler: confirmHandler)
        alert.addAction(action)
        alert.preferredAction = action
        return alert
    }

    /**
    Init pre permission alert.
    - Parameters:
    - permission: an instance of permission to request permissions.
    */
    override init(permission: Permission) {
        super.init(permission: permission)
        title   = "\(Bundle.main.name) would like to access your \(permission)"
        message = "Please enable access to \(permission)."
        cancel  = "Cancel"
        confirm = "Confirm"
    }

    private func confirmHandler(_ action: UIAlertAction) {
        permission.requestAuthorization(callbacks)
    }
}
