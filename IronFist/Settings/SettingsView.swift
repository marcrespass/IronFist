//
//  SettingsView.swift
//  IronFist
//
//  Created by Marc Respass on 5/24/21.
//

import SwiftUI
import IronFistKit

struct SettingsView: View {
    @EnvironmentObject var controller: IronFistController
    @Environment(\.presentationMode) var presentationMode

    var appName: String {
        let name = NSLocalizedString("Iron Fist", comment: "App name")
        return name
    }

    var aboutLabel: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        let label = "\(NSLocalizedString("version", comment: "")) \(version) (\(build))"
        return label
    }

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
                }
            }

            HStack {
                Text(appName)
                    .fontWeight(.bold)
                Text(aboutLabel)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
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
