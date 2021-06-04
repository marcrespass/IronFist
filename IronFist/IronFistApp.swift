//
//  IronFistApp.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI

public enum Constants {
    static let kFistTime = "FistTime"
    static let kRestTime = "RestTime"
}

@main
struct IronFistApp: App {
    @StateObject var controller: TimerController

    init() {
        UserDefaults.standard.register(defaults: [Constants.kRestTime : 5, Constants.kFistTime : 15])
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
