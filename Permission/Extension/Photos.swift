//
//  Photos.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import Photos

/// Permission's extension to Photos.
extension Permission {
    /// Status
    var statusPhotos: PermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:          return .authorized
        case .denied, .restricted: return .denied
        default:                   return .notDetermined
        }
    }
    
    /**
    Regust to autorized.
    - Parameters:
    - callback: Permission's callbac 'Callback'
    */
    func requestPhotos(_ callback: @escaping Callback) {
        PHPhotoLibrary.requestAuthorization { _ in
            callback(self.statusPhotos)
        }
    }
}

