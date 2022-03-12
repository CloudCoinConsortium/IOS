//
//  Settings.swift
//  cloudcoin
//
//  Created by Moumita China on 30/01/22.
//

import Foundation

class Settings : NSObject{
    
    fileprivate let defaults = UserDefaults.standard
    
    var appIsOffline = false
    
    var isFolderCreated : Bool{
        get{
            if(defaults.object(forKey: "isFolderCreated") == nil)
            {
                return false
            }
            return defaults.bool(forKey: "isFolderCreated")
        }
        set{
            defaults.set(newValue, forKey: "isFolderCreated")
        }
    }
    var isFirstTime: Bool{
        get{
            if(defaults.object(forKey: "isFirstTime") == nil)
            {
                return true
            }
            return defaults.bool(forKey: "isFirstTime")
        }
        set{
            defaults.set(newValue, forKey: "isFirstTime")
        }
    }
    private static var instance = Settings()
    
    // MARK: Static
    internal static func shared() -> Settings {
        return instance
    }
    
}


