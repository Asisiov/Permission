//
//  Bluetooth.swift
//
//  Created by Sisov Alexandr on 10/17/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import CoreBluetooth

fileprivate let BluetoothManager = CBCentralManager(delegate: Permission.bluetooth, queue: nil)

/// Permission's extension to Bluetooth
extension Permission {
    // Status
    var statusBluetooth: PermissionStatus {
        switch BluetoothManager.authorization {
        case .restricted:    return .disabled
        case .denied:        return .denied
        case .notDetermined, .allowedAlways: break
        default:
            fatalError()
        }
        
        guard UserDefaults.standard.stateBluetoothManagerDetermined else { return .notDetermined }
        
        switch BluetoothManager.state {
        case .unsupported, .poweredOff: return .disabled
        case .unauthorized:             return .denied
        case .poweredOn:                return .authorized
        case .resetting, .unknown:
            return UserDefaults.standard.statusBluetooth ?? .notDetermined
        default:
            fatalError()
        }
    }
    
    /**
    Regust to autorized.
    - Parameters:
    - callback: Permission's callbac 'Callback'
    */
    func requestBluetooth(_ callback: Callback?) {
        UserDefaults.standard.requestedBluetooth = true
    }
}

extension Permission: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        UserDefaults.standard.stateBluetoothManagerDetermined = true
        UserDefaults.standard.statusBluetooth = statusBluetooth
        guard UserDefaults.standard.requestedBluetooth else { return }
        callback?(statusBluetooth)
        UserDefaults.standard.requestedBluetooth = false
    }
}
