//
//  MediaLibrary.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import MediaPlayer

/// Permission's extension to Media Library
extension Permission {
    /// Status
    var statusMediaLibrary: PermissionStatus {
        let status = MPMediaLibrary.authorizationStatus()
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
    func requestMediaLibrary(_ callback: @escaping Callback) {
        MPMediaLibrary.requestAuthorization { _ in
            callback(self.statusMediaLibrary)
        }
    }
}
