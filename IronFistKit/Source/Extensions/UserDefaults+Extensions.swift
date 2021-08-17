//
//  UserDefaults+Extensions.swift
//  IronFistKit
//
//  Created by Marc Respass on 8/17/21.
//

import Foundation

public extension UserDefaults {
    enum Keys {
        public static let kFistTime = "FistTime"
        public static let kRestTime = "RestTime"
        public static let kRepetition = "Repetition"
        public static let kSpeakTitle = "SpeakTitle"
        public static let kSpeakDescription = "SpeakDescription"
        public static let kSpeakMotivation = "SpeakMotivation"
        public static let kDaySelection = "DaySelection"
    }

    static var defaultsDictionary: [String: Any] {
        if ProcessInfo.processInfo.arguments.contains("-testingMode") {
            return [UserDefaults.Keys.kRestTime: 3,
                    UserDefaults.Keys.kFistTime: 5,
                    UserDefaults.Keys.kRepetition: 1,
                    UserDefaults.Keys.kSpeakTitle: false,
                    UserDefaults.Keys.kSpeakDescription: false,
                    UserDefaults.Keys.kSpeakMotivation: false
            ]
        } else {
            return [UserDefaults.Keys.kRestTime: 5,
                    UserDefaults.Keys.kFistTime: 15,
                    UserDefaults.Keys.kRepetition: 1,
                    UserDefaults.Keys.kSpeakTitle: true,
                    UserDefaults.Keys.kSpeakDescription: true,
                    UserDefaults.Keys.kSpeakMotivation: true
            ]
        }
    }

    /// if -resetDefaults is YES then remove defaults and then register defaults
    func configureDefaults() {
        if ProcessInfo.processInfo.arguments.contains("-resetDefaults") {
            print("WARNING: ---RESETTING DEFAULTS---")
            if let defaultsName = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: defaultsName)
            }
        }
        UserDefaults.standard.register(defaults: UserDefaults.defaultsDictionary)
    }
}