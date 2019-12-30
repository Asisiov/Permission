//
//  Camera.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import AVFoundation

/// Permission's extension to Camera
extension Permission {
    /// Status
    var statusCamera: PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
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
    func requestCamera(_ callback: @escaping Callback) {
        AVCaptureDevice.requestAccess(for: .video) { _ in
            callback(self.statusCamera)
        }
    }
}
