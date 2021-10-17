//
//  SettingsController.swift
//  IronFistKit
//
//  Created by Marc Respass on 7/29/21.
//

import Foundation
import UserNotifications
import SwiftUI

// MARK: - Settings Methods
public final class SettingsController: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published public var fistTime: Int
    @Published public var restTime: Int
    @Published public var repetition: Int
    @Published public var speaksTitle: Bool
    @Published public var speaksDescription: Bool
    @Published public var speaksMotivation: Bool
    // MARK: - Notification properties
    @Published public var selectedTime: Date
    @Published public var daySelection: Set<DaySetting> = []
    @Published public var allowsNotifications: Bool {
        didSet {
            if allowsNotifications == true {
                self.authorizeNotifications()
            } else {
                self.disableNotifications()
            }
        }
    }

    public var canSetNotifications: Bool {
        return allowsNotifications && notificationsEnabled
    }

    private var notificationsEnabled: Bool

    // MARK: - Settings Lazy Properties
    public lazy var appName: String = {
        let name = NSLocalizedString("Iron Fist", comment: "App name")
        return name
    }()

    public lazy var aboutLabel: String = {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        let label = "\(version) (\(build))"
        return label
    }()

    override public init() {
        self.fistTime = UserDefaults.standard.integer(forKey: UserDefaults.Keys.kFistTime)
        self.restTime = UserDefaults.standard.integer(forKey: UserDefaults.Keys.kRestTime)
        self.repetition = UserDefaults.standard.integer(forKey: UserDefaults.Keys.kRepetition)
        self.speaksTitle = UserDefaults.standard.bool(forKey: UserDefaults.Keys.kSpeakTitle)
        self.speaksDescription = UserDefaults.standard.bool(forKey: UserDefaults.Keys.kSpeakDescription)
        self.speaksMotivation = UserDefaults.standard.bool(forKey: UserDefaults.Keys.kSpeakMotivation)

        var dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        dateComponents.hour = UserDefaults.standard.integer(forKey: UserDefaults.Keys.kHourSelection)
        dateComponents.minute = UserDefaults.standard.integer(forKey: UserDefaults.Keys.kMinuteSelection)
        dateComponents.calendar = Calendar.current
        dateComponents.timeZone = TimeZone.current

        let theTime = dateComponents.date
        self.selectedTime = theTime ?? Date()
        if let array = UserDefaults.standard.array(forKey: UserDefaults.Keys.kDaySelection) as? [Int] {
            let filtered = DaySetting.days.filter { array.contains($0.id) }
            self.daySelection = Set(filtered)
        }
        self.allowsNotifications = UserDefaults.standard.bool(forKey: UserDefaults.Keys.kAllowsNotifications)
        self.notificationsEnabled = false

        super.init()

        self.checkNotificationStatus()
    }

    public func saveSettings() {
        UserDefaults.standard.set(self.fistTime, forKey: UserDefaults.Keys.kFistTime)
        UserDefaults.standard.set(self.restTime, forKey: UserDefaults.Keys.kRestTime)
        UserDefaults.standard.set(self.repetition, forKey: UserDefaults.Keys.kRepetition)
        UserDefaults.standard.set(self.speaksTitle, forKey: UserDefaults.Keys.kSpeakTitle)
        UserDefaults.standard.set(self.speaksDescription, forKey: UserDefaults.Keys.kSpeakDescription)
        UserDefaults.standard.set(self.speaksMotivation, forKey: UserDefaults.Keys.kSpeakMotivation)

        self.saveDayNotificationSettings()
    }

    public func saveDayNotificationSettings() {
        let mapped = self.daySelection.map { $0.id }
        UserDefaults.standard.set(mapped, forKey: UserDefaults.Keys.kDaySelection)

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.selectedTime)
        let m = dateComponents.minute
        let h = dateComponents.hour
        UserDefaults.standard.set(m, forKey: UserDefaults.Keys.kMinuteSelection)
        UserDefaults.standard.set(h, forKey: UserDefaults.Keys.kHourSelection)

        self.createNotifications()
    }

    // Rich Notifications
    // https://www.avanderlee.com/swift/rich-notifications/
    // https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app
    public func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    self.notificationsEnabled = true
                } else {
                    self.notificationsEnabled = false
                }
            }
        }
    }

    public func authorizeNotifications() {
        if self.notificationsEnabled == false {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                DispatchQueue.main.async {
                    self.notificationsEnabled = success
                    self.allowsNotifications = success
                    if let error = error {
                        print(error.localizedDescription)
                    }
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
        let data = IronFist.loadData()

        for item in self.daySelection {
            let content = UNMutableNotificationContent()
            content.title = "Practice Iron Fist"
            var max = data.count - 2
            if ProcessInfo.processInfo.arguments.contains("-testingMode") {
                max = data.count
            }
            content.body = data[Int.random(in: 0..<max)].motivation

            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.selectedTime)
            dateComponents.weekday = item.id // index + 1 // Sunday = 1

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
