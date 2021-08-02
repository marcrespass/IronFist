//
//  IronFistApp.swift
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI
import IronFistKit

// Build SwiftUI apps for tvOS
// https://www.wwdcnotes.com/notes/wwdc20/10042/
@main
struct IronFistApp: App {
    @StateObject var controller: IronFistController
    @StateObject var settingsController: SettingsController

    init() {
        UserDefaults.standard.register(defaults: Constants.defaultsDictionary)
        let controller = IronFistController()
        _controller = StateObject(wrappedValue: controller)
        let settingsController = SettingsController()
        _settingsController = StateObject(wrappedValue: settingsController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.controller)
                .environmentObject(self.settingsController)
        }
    }
}
