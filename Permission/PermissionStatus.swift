//
//  PermissionStatus.swift
//
//  Created by Sisov Alexandr on 10/3/19.
//  Copyright © 2019 Sisov Alexandr. All rights reserved.
//

import Foundation

/// Enum of statuses
enum PermissionStatus: String {
    /// Authorized
    case authorized    = "Authorized"
    /// Denied
    case denied        = "Denied"
    /// Disabled
    case disabled      = "Disabled"
    /// Not determined
    case notDetermined = "Not Determined"

    internal init?(string: String?) {
        guard let string = string else { return nil }
        self.init(rawValue: string)
    }
}

extension PermissionStatus: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}
