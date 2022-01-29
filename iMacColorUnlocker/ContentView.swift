//
//  ContentView.swift
//  iMacColorUnlocker
//
//  Created by Thomas Povinelli on 1/28/22.
//

import SwiftUI

class Preferences {
    static let defaults = UserDefaults.standard
    
    
    static func setColor(color: ContentView.iMacAccentColor) {
        let number = color.numberValue
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
        ContentView.iMacAccentColor.from(integer: defaults.integer(forKey: "NSColorSimulatedHardwareEnclosureNumber")) ?? .None
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

struct ContentView: View {
    
    enum iMacAccentColor {
        
        static func from(integer: Int) -> iMacAccentColor? {
            switch integer {
            case 3:
                return .Yellow
            case 4:
                return .Green
            case 5:
                return .Blue
            case 6:
                return .Pink
            case 7:
                return .Purple
            case 8:
                return .Orange
            case 0:
                return .None
            default:
                return nil
            }
        }
        
        var numberValue: Int {
            switch self {
            case .Yellow:
                return 3
            case .Green:
                return 4
            case .Blue:
                return 5
            case .Pink:
                return 6
            case .Purple:
                return 7
            case .Orange:
                return 8
            case .None:
                return 0
            }
        }
        
        
        case Yellow
        case Green
        case Blue
        case Pink
        case Purple
        case Orange
        case None
    }
    
    @State var colorsEnabled = false
    @State var currentColor = iMacAccentColor.None
    @State var showError = false
    @State var errorReason = ""
    var body: some View {
        VStack {
            
            Toggle("Enable custom iMac Colors", isOn: $colorsEnabled)
                .onChange(of: colorsEnabled) { enabled in
                    Preferences.enableColor(enabled: colorsEnabled)
                }
            
            Spacer().frame(height: 10)
            
            Picker("Select a color", selection: $currentColor, content: {
                Text("Yellow").tag(iMacAccentColor.Yellow)
                Text("Green").tag(iMacAccentColor.Green)
                Text("Blue").tag(iMacAccentColor.Blue)
                Text("Pink").tag(iMacAccentColor.Pink)
                Text("Purple").tag(iMacAccentColor.Purple)
                Text("Orange").tag(iMacAccentColor.Orange)
                Text("").tag(iMacAccentColor.None)
            }).onChange(of: currentColor) { color in
                Preferences.setColor(color: color)
            }
            
            Spacer().frame(minHeight: 35, idealHeight: 40, maxHeight: 50)
            
            
            Text("Restart any open programs to see the changes.").font(.caption)
            Text("You may also have to open System Preferences and toggle the color").font(.caption)
        }.padding()
            .frame(minWidth: 300, idealWidth: 450, maxWidth: 800)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                for window in NSApplication.shared.windows {
                    window.standardWindowButton(.zoomButton)?.isEnabled = false
                }
            }).onAppear(perform: {
                colorsEnabled = Preferences.isColorEnabled
                currentColor = Preferences.color
                
            })
            .sheet(isPresented: $showError, onDismiss: { } , content: {
                Text(errorReason)
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
