//
//  Copyright © 2015 Onefootball GmbH. All rights reserved.
//

import UIKit

/// Provides a logic for resetting the application data such as library, caches, documents, user defaults, keychain and UIApplication properties.
class ApplicationResetManager: NSObject {
    
    /// Resets all saved data in the application.
    class func reset() {
        clearFiles()
        clearUserDefaults()
        clearKeychain()
        clearApplicationProperties()
    }
    
    // MARK: - Private
    
    private class func clearFiles() {
        let library = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        let caches = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        // Remove this out, if you don't use app groups.
        let groupContainer = filesForGroupIdentifier("com.example.yourapp.group")
        
        let fileManager = NSFileManager()
        for path in library + caches + documents + groupContainer {
            _ = try? fileManager.removeItemAtPath(path)
        }
    }
    
    private class func filesForGroupIdentifier(groupIdentifier: String) -> [String] {
        let fileManager = NSFileManager.defaultManager()
        guard let path = fileManager.containerURLForSecurityApplicationGroupIdentifier(groupIdentifier)?.path else { return [] }
        guard let files = try? fileManager.contentsOfDirectoryAtPath(path) else { return [] }
        return files.map { "\(path)/\($0)" }
    }
    
    private class func clearUserDefaults() {
        // Remove this out, if you don't use app groups.
        let groupUserDefaults = NSUserDefaults(suiteName: "com.example.yourapp.group")
        groupUserDefaults?.clear()
        groupUserDefaults?.synchronize()
        
        let standardUserDefaults = NSUserDefaults.standardUserDefaults()
        standardUserDefaults.clear()
        standardUserDefaults.synchronize()
    }
    
    private class func clearKeychain() {
        let secClasses = [
            kSecClassGenericPassword as String,
            kSecClassInternetPassword as String,
            kSecClassCertificate as String,
            kSecClassKey as String,
            kSecClassIdentity as String
        ]
        
        for secClass in secClasses {
            let query = [kSecClass as String: secClass]
            SecItemDelete(query as CFDictionaryRef)
        }
    }
    
    private class func clearApplicationProperties() {
        let application = UIApplication.sharedApplication()
        if #available(iOS 9.0, *) {
            application.shortcutItems = nil
        }
        application.applicationIconBadgeNumber = 0
    }
}

// MARK: - NSUserDefaults+Clear
extension NSUserDefaults {
    private func clear() {
        for key in dictionaryRepresentation().keys {
            removeObjectForKey(key)
        }
    }
}