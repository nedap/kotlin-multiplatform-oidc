//
//  KeychainAccessibility.swift
//  milo-ios
//
//  Created by Denisia Enasescu on 21/03/2024.
//  Copyright © 2024 Nedap. All rights reserved.
//

import Foundation

@objc public enum KeychainAccessibility: Int {
    case whenUnlocked
    case afterFirstUnlock
    case whenPasscodeSetThisDeviceOnly
    case whenUnlockedThisDeviceOnly
    case afterFirstUnlockThisDeviceOnly
    
    var kSecAttrAccessible: CFString {
        switch self {
        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
            
        case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
            
        case .whenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
            
        case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            
        case .afterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        }
    }
}
