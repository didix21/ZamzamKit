//
//  ZamzamManager.swift
//  ZamzamKit
//
//  Created by Basem Emara on 5/6/15.
//  Copyright (c) 2015 Zamzam. All rights reserved.
//

import Foundation

public class StorageService: NSObject {
    
    /**
    Get stored value from NSUserDefaults with optional default
    
    - parameter key:          key for stored value
    - parameter defaultValue: default value if no value stored
    
    - returns: stored value form NSUserDefaults
    */
    public func getUserValue(key: String, _ storageKey: String?, defaultValue: AnyObject? = nil) -> AnyObject? {
        let userStorage = storageKey != nil
            ? NSUserDefaults(suiteName: storageKey) : NSUserDefaults.standardUserDefaults()
        
        // Get setting from storage or default
        if let value: AnyObject = defaultValue where userStorage?.objectForKey(key) == nil {
            userStorage?.setObject(value, forKey: key)
            userStorage?.synchronize()
        }
        
        return userStorage?.objectForKey(key)
    }
    
    /**
    Set stored value from NSUserDefaults
    
    - parameter key:      key for stored value
    - parameter newValue: value to set
    */
    public func setUserValue(key: String, _ storageKey: String?, newValue: AnyObject?) {
        let userStorage = storageKey != nil
            ? NSUserDefaults(suiteName: storageKey) : NSUserDefaults.standardUserDefaults()
        
        // Set new value in storage
        userStorage?.setObject(newValue, forKey: key)
        userStorage?.synchronize()
    }
    
    /**
     Get stored value from NSUserDefaults with optional default
     
     - parameter key:          key for stored value
     - parameter defaultValue: default value if no value stored
     
     - returns: stored value form NSUserDefaults
     */
    public func getUserValue(key: String, defaultValue: AnyObject? = nil) -> AnyObject? {
        return getUserValue(key, nil, defaultValue: defaultValue)
    }
    
    /**
     Set stored value from NSUserDefaults
     
     - parameter key:      key for stored value
     - parameter newValue: value to set
     */
    public func setUserValue(key: String, newValue: AnyObject?) {
        return setUserValue(key, nil, newValue: newValue)
    }
    
}
