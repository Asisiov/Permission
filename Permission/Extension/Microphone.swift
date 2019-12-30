//
//  Microphone.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import AVFoundation

/// Permision's extensions to Microphone
extension Permission {
    /// Status
    var statusMicrophone: PermissionStatus {
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case AVAudioSession.RecordPermission.denied:  return .denied
        case AVAudioSession.RecordPermission.granted: return .authorized
        default:                                      return .notDetermined
        }
    }
    
    /**
    Regust to autorized.
    - Parameters:
    - callback: Permission's callbac 'Callback'
    */
    func requestMicrophone(_ callback: @escaping Callback) {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            callback(self.statusMicrophone)
        }
    }
}
