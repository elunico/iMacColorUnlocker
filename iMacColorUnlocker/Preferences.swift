//
//  Preferences.swift
//  iMacColorUnlocker
//
//  Created by Thomas Povinelli on 1/30/22.
//

import Foundation

class Preferences {
    static let defaults = UserDefaults.standard

    static func setColor(color: ContentView.iMacAccentColor) {
        let number = color.rawValue
        assert(3 <= number && number <= 8, "Invalid color number")
        setGlobal(value: number, forKey: "NSColorSimulatedHardwareEnclosureNumber")
        print("Color value is now set to \(number)")
        defaults.synchronize()
    }
    
    private static func setGlobal(value: Bool, forKey key: String) {
        var domain = defaults.persistentDomain(forName: UserDefaults.globalDomain)
        if domain != nil {
            domain![key] = value
            defaults.setPersistentDomain(domain!, forName: UserDefaults.globalDomain)
        }
    }
    
    private static func setGlobal(value: Int, forKey key: String) {
        var domain = defaults.persistentDomain(forName: UserDefaults.globalDomain)
        if domain != nil {
            domain![key] = value
            defaults.setPersistentDomain(domain!, forName: UserDefaults.globalDomain)
        }
    }
    
    static var color: ContentView.iMacAccentColor {
        ContentView.iMacAccentColor.from(integer: defaults.integer(forKey: "NSColorSimulatedHardwareEnclosureNumber"))
    }
    
    static func enableColor(enabled: Bool) {
        setGlobal(value: enabled, forKey: "NSColorSimulateHardwareAccent")
        print("Color is now \(enabled)")
        defaults.synchronize()
    }
    
    static var isColorEnabled: Bool {
        defaults.bool(forKey: "NSColorSimulateHardwareAccent")
    }
}
