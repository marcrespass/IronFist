//
//  SettingsView.swift
//  IronFist
//
//  Created by Marc Respass on 5/24/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var controller: TimerController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Settings", comment: ""))) {
                Stepper("Rice time: \(controller.fistTime)", value: $controller.fistTime)
                Stepper("Rest time: \(controller.restTime)", value: $controller.restTime)
            }
            Section {
                Button("Done") { presentationMode.wrappedValue.dismiss() }
            }
        }
        .onDisappear(perform: save)
    }

    func save() {
        self.controller.saveSettings()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var controller = TimerController()

    static var previews: some View {
        SettingsView()
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
