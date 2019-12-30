//
//  PermissionType.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import Foundation

/// Enum of permission's type.
enum PermissionType {
    /// Permissions for contacts
    case contacts
    /// Permissions for location
    case locationWhenInUse
    /// Permissions for microphone
    case microphone
    /// Permissions for camera
    case camera
    /// Permissions for photos
    case photos
    /// Permissions for events
    case events
    /// Permissions for media library
    case mediaLibrary
    /// Permissions for bluetooth
    case bluetooth
    /// Permissions for motion
    case motion
    /// Permissions from notification
    case notification
}

extension PermissionType: CustomStringConvertible {
    var description: String {
        if case .contacts          = self { return "Contacts" }
        if case .locationWhenInUse = self { return "Location" }
        if case .microphone        = self { return "Microphone" }
        if case .camera            = self { return "Camera" }
        if case .photos            = self { return "Photos" }
        if case .events            = self { return "Events" }
        if case .mediaLibrary      = self { return "Media Library" }
        if case .bluetooth         = self { return "Bluetooth" }
        if case .motion            = self { return "Motion" }
        if case .notification      = self { return "Notification" }
        fatalError()
    }
}
