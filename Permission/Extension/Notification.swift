//
//  Notification.swift
//
//  Created by Sisov on 10.12.2019.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import UserNotifications

extension Permission {
    /// Permission status
    var statusNotification: PermissionStatus {
        if UserDefaults.standard.requestedNotifications {
            return synchronousStatusNotification
        }
        
        return .notDetermined
    }
    
    /**
     Requests autorization to notification
     - parameter callback autorization callback
     */
    func requestNotification(_ callback: @escaping Callback) {
        UserDefaults.standard.requestedNotifications = true
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted {
                    callback(.authorized)
                    return
                }
                
                callback(.denied)
        }
    }
}

private extension Permission {
    var synchronousStatusNotification: PermissionStatus {
        let semaphore = DispatchSemaphore(value: 0)
        var status: PermissionStatus = .notDetermined
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized: status = .authorized
            case .denied: status = .denied
            default: break
            }
            
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        return status
    }
}
