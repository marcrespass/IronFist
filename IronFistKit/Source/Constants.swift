//
//  Constants.swift
//
//  Created by Marc Respass on 7/8/21.
//

import Foundation

public enum Constants {
    public static let kFistTime = "FistTime"
    public static let kRestTime = "RestTime"
    public static let kSpeakTitle = "SpeakTitle"
    public static let kSpeakDescription = "SpeakDescription"
    public static let kSpeakMotivation = "SpeakMotivation"

    public static let kSelectedDay1 = "SelectedDay1"
    public static let kSelectedDay2 = "SelectedDay2"
    public static let kSelectedDay3 = "SelectedDay3"
    public static let kSelectedDay4 = "SelectedDay4"
    public static let kSelectedDay5 = "SelectedDay5"
    public static let kSelectedDay6 = "SelectedDay6"
    public static let kSelectedDay7 = "SelectedDay7"

    public static var defaultsDictionary: [String: Any] {
        #if DEBUG
        [Constants.kRestTime: 3,
         Constants.kFistTime: 5,
         Constants.kSpeakTitle: false,
         Constants.kSpeakDescription: false,
         Constants.kSpeakMotivation: false
        ]
        #else
        [Constants.kRestTime: 5,
         Constants.kFistTime: 15,
         Constants.kSpeakTitle: true,
         Constants.kSpeakDescription: true,
         Constants.kSpeakMotivation: true
        ]
        #endif
    }
}
