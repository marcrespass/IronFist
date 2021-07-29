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

    var body: some View {
        VStack {
            topBar()
            Form {
                timeSection()
                speakSection()
                notificationSection()
            }
            bottomBar()
        }
    }

    fileprivate func bottomBar() -> some View {
        HStack {
            Text(controller.appName)
                .fontWeight(.bold)
            Text(controller.aboutLabel)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        }
    }

    fileprivate func topBar() -> some View {
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
    }

    fileprivate func timeSection() -> some View {
        Section(header: Text("Time")) {
            Stepper("Rice time: \(controller.fistTime)", value: $controller.fistTime)
            Stepper("Rest time: \(controller.restTime)", value: $controller.restTime)
        }
    }

    fileprivate func speakSection() -> some View {
        Section(header: Text("Speak")) {
            Toggle("Speak titles", isOn: $controller.speakTitle)
            Toggle("Speak descriptions", isOn: $controller.speakDescription)
            Toggle("Speak motivations", isOn: $controller.speakMotivation)
        }
    }

    fileprivate func notificationSection() -> some View {
        return Section(header: Text("Configure notifications")) {
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
