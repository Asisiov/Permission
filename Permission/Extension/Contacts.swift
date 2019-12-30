//
//  Contacts.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import Contacts

/// Permission's extension to Contacts
extension Permission {
    /// Status
    var statusContacts: PermissionStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
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
    func requestContacts(_ callback: @escaping Callback) {
        CNContactStore().requestAccess(for: .contacts) { _, _ in
            callback(self.statusContacts)
        }
    }
}
