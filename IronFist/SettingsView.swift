//
//  SettingsView.swift
//  IronFist
//
//  Created by Marc Respass on 5/24/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var controller: IronFistController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Settings", comment: ""))) {
                Stepper("Fist time: \(controller.fistTime)", value: $controller.fistTime)
                Stepper("Rest time: \(controller.restTime)", value: $controller.restTime)
            }
            Section {
                Button("Done") { presentationMode.wrappedValue.dismiss() }
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: save)
    }

    func save() {
        self.controller.saveSettings()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var controller = IronFistController()

    static var previews: some View {
        SettingsView()
            .previewLayout(.sizeThatFits)
            .environmentObject(controller)
    }
}
