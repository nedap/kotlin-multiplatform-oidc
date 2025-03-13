//
//  LocalStorage.swift
//  milo-ios
//
//  Created by Denisia Enasescu on 21/03/2024.
//  Copyright © 2024 Nedap. All rights reserved.
//

import Foundation

@objc public protocol LocalStorage {
    func readValue(forKey key: String) throws -> Any
    func storeValue(_ value: Any, forKey key: String) throws
    func deleteValue(forKey key: String) throws
}
