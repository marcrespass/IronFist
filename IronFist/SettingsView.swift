//
//  SettingsView.swift
//  IronFist
//
//  Created by Marc Respass on 5/24/21.
//

import SwiftUI

extension NumberFormatter {
    static var plainNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}

struct SettingsView: View {
    var controller: IronFistController
    @Environment(\.presentationMode) var presentationMode
    @State private var localFistTime: Int
    @State private var localRestTime: Int

    init(controller: IronFistController) {
        self.controller = controller
        _localFistTime = State(wrappedValue: controller.fistTime)
        _localRestTime = State(wrappedValue: controller.restTime)
    }

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("Settings", comment: ""))) {
                Stepper("Fist time: \(localFistTime)", value: $localFistTime)
                Stepper("Rest time: \(localRestTime)", value: $localRestTime)
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
        SettingsView(controller: controller)
            .previewLayout(.sizeThatFits)
    }
}
