//
//  ContentView.swift
//  iMacColorUnlocker
//
//  Created by Thomas Povinelli on 1/28/22.
//

import SwiftUI

struct ContentView: View {
    
    enum iMacAccentColor: Int, CaseIterable, Identifiable {
        var id: Int {
            rawValue
        }
        
        typealias ID = Int
        
        static func from(integer: Int) -> iMacAccentColor {
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
            default:
                return .None
            }
        }
        
        case Yellow = 3
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
                ForEach(iMacAccentColor.allCases) { item in
                    Text(String(describing: item)).tag(item)
                }
            }).onChange(of: currentColor) { color in
                Preferences.setColor(color: color)
            }
            
            Spacer().frame(minHeight: 35, idealHeight: 40, maxHeight: 50)
            
            
            Text("Restart any open programs to see the changes.").font(.caption)
            Text("You may also have to open System Preferences and toggle the color").font(.caption)
        }.padding()
            .frame(minWidth: 350, idealWidth: 450, maxWidth: 500)
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
