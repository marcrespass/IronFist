//
//  IronFistApp.swift
//  Shared
//
//  Created by Marc Respass on 5/21/21.
//

import SwiftUI
import IronFistKit

@main
struct IronFistApp: App {
    @StateObject var controller: IronFistController

    init() {
        UserDefaults.standard.register(defaults: Constants.defaultsDictionary)
        let controller = IronFistController()
        _controller = StateObject(wrappedValue: controller)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.controller)
        }
    }
}
