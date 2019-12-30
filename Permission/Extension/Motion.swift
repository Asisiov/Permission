//
//  Motion.swift
//
//  Created by Sisov Alexandr on 10/17/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import CoreMotion

private let MotionManager = CMMotionActivityManager()

/// Permission's extension to Motion
extension Permission {
    /// Status
    var statusMotion: PermissionStatus {
        if UserDefaults.standard.requestedMotion {
            return synchronousStatusMotion
        }
        return .notDetermined
    }
    
    /**
    Regust to autorized.
    - Parameters:
    - callback: Permission's callbac 'Callback'
    */
    func requestMotion(_ callback: Callback?) {
        UserDefaults.standard.requestedMotion = true
        
        let now = Date()
        
        MotionManager.queryActivityStarting(from: now, to: now, to: .main) { activities, error in
            let status: PermissionStatus
            
            if  let error = error , error._code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                status = .denied
            } else {
                status = .authorized
            }
            
            MotionManager.stopActivityUpdates()
            
            callback?(status)
        }
    }
    
    private var synchronousStatusMotion: PermissionStatus {
        let semaphore = DispatchSemaphore(value: 0)
        
        var status: PermissionStatus = .notDetermined
        
        let now = Date()
        
        MotionManager.queryActivityStarting(from: now, to: now, to: .background) { activities, error in
            if  let error = error , error._code == Int(CMErrorMotionActivityNotAuthorized.rawValue) {
                status = .denied
            } else {
                status = .authorized
            }
            
            MotionManager.stopActivityUpdates()
            
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .distantFuture)
        
        return status
    }
    
}
