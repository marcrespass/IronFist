//
//  Constants.swift
//
//  Created by Marc Respass on 7/8/21.
//

import Foundation

public enum Constants {
    public static let kFistTime = "FistTime"
    public static let kRestTime = "RestTime"
    public static let kRepetition = "Repetition"
    public static let kSpeakTitle = "SpeakTitle"
    public static let kSpeakDescription = "SpeakDescription"
    public static let kSpeakMotivation = "SpeakMotivation"
    public static let kDaySelection = "DaySelection"

    public static var defaultsDictionary: [String: Any] {
        #if DEBUG
        [Constants.kRestTime: 3,
         Constants.kFistTime: 5,
         Constants.kRepetition: 1,
         Constants.kSpeakTitle: false,
         Constants.kSpeakDescription: false,
         Constants.kSpeakMotivation: false
        ]
        #else
        [Constants.kRestTime: 5,
         Constants.kFistTime: 15,
         Constants.kRepetition: 1,
         Constants.kSpeakTitle: true,
         Constants.kSpeakDescription: true,
         Constants.kSpeakMotivation: true
        ]
        #endif
    }
}
