//
//  Events.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import EventKit

/// Permission's extension for events
internal extension Permission {
    /// Status
    var statusEvents: PermissionStatus {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:          return .authorized
        case .restricted, .denied: return .denied
        default:                   return .notDetermined
        }
    }
    
    /**
     Regust to autorized.
     - Parameters:
     - callback: Permission's callbac 'Callback'
     */
    func requestEvents(_ callback: @escaping Callback) {
        EKEventStore().requestAccess(to: .event) { _, _ in
            callback(self.statusEvents)
        }
    }
}
