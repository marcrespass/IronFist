//
//  Constants.swift
//  IronFistKit
//
//  Created by Marc Respass on 7/8/21.
//

import Foundation

public enum Constants {
    public static let kFistTime = "FistTime"
    public static let kRestTime = "RestTime"
    public static let kSpeakExercises = "SpeakExercises"
    public static var defaultsDictionary: [String: Any] {
        #if DEBUG
        [Constants.kRestTime: 3,
         Constants.kFistTime: 5,
         Constants.kSpeakExercises: false]
        #else
        [Constants.kRestTime: 5,
         Constants.kFistTime: 15,
         Constants.kSpeakExercises: true]
        #endif
    }
}
