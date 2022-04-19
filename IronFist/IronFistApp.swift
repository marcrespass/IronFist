//
//  IronFistApp.swift
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI
import IronFistKit

// Build SwiftUI apps for tvOS
// https://www.wwdcnotes.com/notes/wwdc20/10042/

// State restoration in SwiftUI
// https://swiftwithmajid.com/2022/03/10/state-restoration-in-swiftui/
@main
struct IronFistApp: App {
    @StateObject var controller: IronFistController
    @StateObject var settingsController: SettingsController

    init() {
        UserDefaults.standard.configureDefaults()
        _controller = StateObject(wrappedValue: IronFistController())
        _settingsController = StateObject(wrappedValue: SettingsController())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.controller)
                .environmentObject(self.settingsController)
        }
    }
}
