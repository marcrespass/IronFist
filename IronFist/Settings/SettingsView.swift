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
        VStack {
            HStack {
                Text("Settings")
                    .font(.largeTitle.bold())
                Spacer()
                Button("Done") {
                    self.controller.saveSettings()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding([.top, .leading, .trailing])

            Form {
                Section {
                    Stepper("Rice time: \(controller.fistTime)", value: $controller.fistTime)
                    Stepper("Rest time: \(controller.restTime)", value: $controller.restTime)
                }
            }
        }
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
