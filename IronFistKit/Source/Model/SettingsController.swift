//
//  SettingsController.swift
//  IronFistKit
//
//  Created by Marc Respass on 7/29/21.
//

import Foundation
import UserNotifications

// MARK: - Settings Methods
public final class SettingsController: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published public var fistTime: Int
    @Published public var restTime: Int
    @Published public var speaksTitle: Bool
    @Published public var speaksDescription: Bool
    @Published public var speaksMotivation: Bool
    // MARK: - Notification properties
    @Published public var selectedTime: Date = Date()
    @Published public var day1: Bool
    @Published public var day2: Bool
    @Published public var day3: Bool
    @Published public var day4: Bool
    @Published public var day5: Bool
    @Published public var day6: Bool
    @Published public var day7: Bool
    @Published public var allowsNotifications: Bool

    // MARK: - Settings Lazy Properties
    public lazy var appName: String = {
        let name = NSLocalizedString("Iron Fist", comment: "App name")
        return name
    }()

    public lazy var aboutLabel: String = {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        let label = "\(NSLocalizedString("version", comment: "")) \(version) (\(build))"
        return label
    }()

    override public init() {
        self.fistTime = UserDefaults.standard.integer(forKey: Constants.kFistTime)
        self.restTime = UserDefaults.standard.integer(forKey: Constants.kRestTime)
        self.speaksTitle = UserDefaults.standard.bool(forKey: Constants.kSpeakTitle)
        self.speaksDescription = UserDefaults.standard.bool(forKey: Constants.kSpeakDescription)
        self.speaksMotivation = UserDefaults.standard.bool(forKey: Constants.kSpeakMotivation)

        self.day1 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay1)
        self.day2 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay2)
        self.day3 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay3)
        self.day4 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay4)
        self.day5 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay5)
        self.day6 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay6)
        self.day7 = UserDefaults.standard.bool(forKey: Constants.kSelectedDay7)

        self.allowsNotifications = false

        super.init()

        self.checkNotificationStatus()
    }

    public func saveSettings() {
        UserDefaults.standard.set(self.fistTime, forKey: Constants.kFistTime)
        UserDefaults.standard.set(self.restTime, forKey: Constants.kRestTime)
        UserDefaults.standard.set(self.speaksTitle, forKey: Constants.kSpeakTitle)
        UserDefaults.standard.set(self.speaksDescription, forKey: Constants.kSpeakDescription)
        UserDefaults.standard.set(self.speaksMotivation, forKey: Constants.kSpeakMotivation)

        UserDefaults.standard.set(self.day1, forKey: Constants.kSelectedDay1)
        UserDefaults.standard.set(self.day2, forKey: Constants.kSelectedDay2)
        UserDefaults.standard.set(self.day3, forKey: Constants.kSelectedDay3)
        UserDefaults.standard.set(self.day4, forKey: Constants.kSelectedDay4)
        UserDefaults.standard.set(self.day5, forKey: Constants.kSelectedDay5)
        UserDefaults.standard.set(self.day6, forKey: Constants.kSelectedDay6)
        UserDefaults.standard.set(self.day7, forKey: Constants.kSelectedDay7)

        self.createNotifications()
    }

    // https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
    public func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.allowsNotifications = true
                } else {
                    self.allowsNotifications = false
                }
            }
        }
    }

    public func allowNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.allowsNotifications = true
                } else if let error = error {
                    print(error.localizedDescription)
                    self.allowsNotifications = false
                }
            }
        }
    }

    private func disableNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
    // https://www.hackingwithswift.com/books/ios-swiftui/scheduling-local-notifications
    // This one shows how to handle if notifications are disabled in Settings
    // https://blog.techchee.com/handling-local-notification-in-swiftui/
    private func createNotifications() {
        self.disableNotifications()
        let days = [day1, day2, day3, day4, day5, day6, day7]
        let data = IronFist.loadData()

        for (index, item) in days.enumerated() where item == true {
            let content = UNMutableNotificationContent()
            content.title = "Practice Iron Fist"
            var max = data.count - 2
            if ProcessInfo.processInfo.arguments.contains("-testingMode") {
                max = data.count
            }
            content.body = data[Int.random(in: 0..<max)].motivation

            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.selectedTime)
            dateComponents.weekday = index + 1 // Sunday = 1

            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            // Create the request
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
