//
//  Keychain.swift
//  milo-ios
//
//  Created by Denisia Enasescu on 18/03/2024.
//  Copyright © 2024 Nedap. All rights reserved.
//

import Foundation

@objc public enum KeychainError: Int, Error {
    case failed, notFound, invalidDecoderClass
}

@objcMembers public final class Keychain: NSObject, LocalStorage {
    private let service: String
    private let accessGroup: String?
    private let accessibility: KeychainAccessibility
    private let classes: [AnyClass]

    private var genericQuery: [String: Any] {
        var query = [
            kSecAttrService: service,
            kSecClass: kSecClassGenericPassword
        ] as [String: Any]
        
        #if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        #endif
        
        return query
    }
    
    public init(service: String, accessGroup: String? = nil, accessibility: KeychainAccessibility, decoderClasses classes: [AnyClass]) {
        self.service = service
        self.accessGroup = accessGroup
        self.accessibility = accessibility
        self.classes = classes
    }
    
    public func readValue(forKey key: String) throws -> Any {
        guard let retrievedItem = searchItem(forKey: key) as? [String: Any],
              let encodedData = retrievedItem[kSecValueData as String] as? Data else {
            throw KeychainError.notFound
        }
                        
        if let encodedItem = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: classes, from: encodedData) {
            try validateAllowedClass(encodedItem: encodedItem)
            return encodedItem
        }
        
        var format: PropertyListSerialization.PropertyListFormat = .binary
        if let propertyListItem = try? PropertyListSerialization.propertyList(from: encodedData, options: [], format: &format), format == .binary {
            return propertyListItem
        }
        
        if let stringItem = String(data: encodedData, encoding: .utf8)  {
            return stringItem
        }
        
        throw KeychainError.failed
    }
    
    public func storeValue(_ value: Any, forKey key: String) throws {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true) else {
            throw KeychainError.failed
        }
        
        var query = genericQuery
        query[kSecAttrAccount as String] = key
        query[kSecAttrAccessible as String] = accessibility.kSecAttrAccessible
        
        if let _ = searchItem(forKey: key) {
            try updateItem(query, withNewData: data)
        } else {
            try insertItem(query, withData: data)
        }
    }
    
    public func deleteValue(forKey key: String) throws {
        var query = genericQuery
        query[kSecAttrAccount as String] = key
        
        print(">> Delete query:\n\(query)")
        let status = SecItemDelete(query as CFDictionary)
        guard didOperationSucceess(status: status) || status == errSecItemNotFound else { throw KeychainError.failed }
    }
    
    // MARK: - Helpers
    
    private func validateAllowedClass(encodedItem: Any) throws {
#if DEBUG
        let isAllowedClass = classes.contains { decoderClass in
            (encodedItem as AnyObject).isKind(of: decoderClass)
        }
        
        if !isAllowedClass {
            throw KeychainError.invalidDecoderClass
        }
#endif
    }
    
    private func insertItem(_ query: [String: Any], withData data: Data) throws {
        var updatedQuery = query
        updatedQuery[kSecValueData as String] = data
        updatedQuery[kSecReturnData as String] = kCFBooleanTrue as Any
        updatedQuery[kSecReturnAttributes as String] = kCFBooleanTrue as Any
        
        print(">> Insert query:\n\(updatedQuery)")
        let status = SecItemAdd(updatedQuery as CFDictionary, nil)
        guard didOperationSucceess(status: status) else { throw KeychainError.failed }
    }
    
    private func updateItem(_ query: [String: Any], withNewData data: Data) throws {
        let attributesToUpdate = [
            kSecValueData: data
        ] as [String: Any]
        
        print(">> Update query:\n\(query)\n\nUpdated attributes:\n\(attributesToUpdate)")
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.notFound }
        guard didOperationSucceess(status: status) else { throw KeychainError.failed }
    }
    
    private func searchItem(forKey key: String) -> AnyObject? {
        var query = genericQuery
        query[kSecAttrAccount as String] = key
        query[kSecReturnData as String] = kCFBooleanTrue as Any
        query[kSecReturnAttributes as String] = kCFBooleanTrue as Any
        query[kSecMatchLimit as String] = kSecMatchLimitOne as Any
        
        print(">> Search query:\n\(query)")
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        _ = didOperationSucceess(status: status)
        return item
    }
    
    private func didOperationSucceess(status: OSStatus) -> Bool {
        
        switch status {
        case errSecSuccess:
            print(">> Operation Succeeded")
            return true
        default:
            let errMsg = SecCopyErrorMessageString(status, nil) as? String ?? "Unknown error"
            print(">> Operation Failed: \(errMsg)")
            return false
        }
        
    }
}
