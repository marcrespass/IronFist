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
                Section {
                    Toggle("Speak exercises", isOn: $controller.speakExercises)
//                    Toggle("Speak rests", isOn: $controller.speakExercises)
                }
            }
        }
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
