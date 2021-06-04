//
//  IronFistApp.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI

@main
struct IronFistApp: App {
    @StateObject var controller: TimerController

    init() {
        UserDefaults.standard.register(defaults: ["RestTime" : 5, "FistTime" : 15])
        let controller = TimerController()
        _controller = StateObject(wrappedValue: controller)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.controller)
        }
    }
}
