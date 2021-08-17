//
//  SettingsView.swift
//
//  Created by Marc Respass on 5/24/21.
//

import SwiftUI
import IronFistKit

struct SettingsView: View {
    @EnvironmentObject var settingsController: SettingsController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            topBar()
            Form {
                timeSection()
                repetitionSection()
                speakSection()
                notificationSection()
            }
            bottomBar()
        }
    }
}

// MARK: - Private View methods
extension SettingsView {
    fileprivate func bottomBar() -> some View {
        HStack {
            Text(settingsController.appName)
                .fontWeight(.bold)
            Text(settingsController.aboutLabel)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        }
    }

    fileprivate func topBar() -> some View {
        HStack {
            Text("Settings")
                .font(.largeTitle.bold())
            Spacer()
            Button {
                self.settingsController.saveSettings()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done").font(.title3)
            }
        }
        .padding([.top, .leading, .trailing])
    }

    fileprivate func timeSection() -> some View {
        Section(header: Text("Time")) {
            Stepper("Rice time: \(settingsController.fistTime)", value: $settingsController.fistTime)
            Stepper("Rest time: \(settingsController.restTime)", value: $settingsController.restTime)
        }
    }

    fileprivate func repetitionSection() -> some View {
        Section(header: Text("Repetitions")) {
            Stepper("Repeat: \(settingsController.repetition)", value: $settingsController.repetition)
        }
    }

    fileprivate func speakSection() -> some View {
        Section(header: Text("Speak")) {
            Toggle("Speak titles", isOn: $settingsController.speaksTitle)
            Toggle("Speak descriptions", isOn: $settingsController.speaksDescription)
            Toggle("Speak motivations", isOn: $settingsController.speaksMotivation)
        }
    }

    fileprivate func notificationSection() -> some View {
        return Section(header: Text("Configure notifications")) {
            DatePicker("Hour", selection: $settingsController.selectedTime, displayedComponents: [.hourAndMinute])
            if self.settingsController.allowsNotifications {
                List(DaySetting.days, id: \.self) { day in
                    HStack {
                        Text(LocalizedStringKey(day.name))
                        Spacer()
                        Image(systemName: self.settingsController.daySelection.contains(day) ? "checkmark.square" : "square")
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
                    .onTapGesture {
                        if self.settingsController.daySelection.contains(day) {
                            self.settingsController.daySelection.remove(day)
                        } else {
                            self.settingsController.daySelection.insert(day)
                        }
                        self.settingsController.saveDayNotificationSettings()
                    }
                }
            } else {
                Button("Allow notifications") {
                    self.settingsController.allowNotifications()
                }
            }
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var controller = SettingsController()

    static var previews: some View {
        SettingsView()
            .previewLayout(.sizeThatFits)
            .environment(\.locale, .init(identifier: "es"))
            .environmentObject(controller)
    }
}
#endif
