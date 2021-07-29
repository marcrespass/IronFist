//
//  SettingsView.swift
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
                Button {
                    self.controller.saveSettings()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done").font(.title3)
                }
            }
            .padding([.top, .leading, .trailing])

            Form {
                Section(header: Text("Time")) {
                    Stepper("Rice time: \(controller.fistTime)", value: $controller.fistTime)
                    Stepper("Rest time: \(controller.restTime)", value: $controller.restTime)
                }
                Section(header: Text("Speak")) {
                    Toggle("Speak titles", isOn: $controller.speakTitle)
                    Toggle("Speak descriptions", isOn: $controller.speakDescription)
                    Toggle("Speak motivations", isOn: $controller.speakMotivation)
                }
                Section(header: Text("Configure notifications")) {
                    if self.controller.allowsNotifications {
                        DatePicker("Hour", selection: $controller.selectedTime, displayedComponents: [.hourAndMinute])
                        Toggle("Sunday", isOn: $controller.day1)
                            .toggleStyle(CheckboxToggleStyle())
                        Toggle("Monday", isOn: $controller.day2)
                            .toggleStyle(CheckboxToggleStyle())
                        Toggle("Tuesday", isOn: $controller.day3)
                            .toggleStyle(CheckboxToggleStyle())
                        Toggle("Wednesday", isOn: $controller.day4)
                            .toggleStyle(CheckboxToggleStyle())
                        Toggle("Thursday", isOn: $controller.day5)
                            .toggleStyle(CheckboxToggleStyle())
                        Toggle("Friday", isOn: $controller.day6)
                            .toggleStyle(CheckboxToggleStyle())
                        Toggle("Saturday", isOn: $controller.day7)
                            .toggleStyle(CheckboxToggleStyle())
                    } else {
                        Button("Allow notifications") {
                            self.controller.allowNotifications()
                        }
                    }
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

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var controller = IronFistController()

    static var previews: some View {
        SettingsView()
            .previewLayout(.sizeThatFits)
            .environment(\.locale, .init(identifier: "es"))
            .environmentObject(controller)
    }
}
#endif
