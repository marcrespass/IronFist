//
//  CircleState.swift
//  CombineTimer
//
//  Created by Marc Respass on 6/1/21.
//

import SwiftUI

public enum CircleState: Equatable {
    case fist
    case rest

    public var shadowColor: Color {
        switch self {
            case .fist:
                return Color("shadowColor-1")
            case .rest:
                return Color("shadowColor-2")
        }
    }

    public var baseAccentColor: Color {
        switch self {
            case .fist:
                return Color("baseAccentColor-1")
            case .rest:
                return Color("baseAccentColor-2")
        }
    }

    public var symbol: String {
        switch self {
            case .fist:
                return "👊"
            case .rest:
                return "🖐"
        }
    }

    public var timerValue: TimeInterval {
        switch self {
            case .fist:
                return TimeInterval(UserDefaults.standard.integer(forKey: "FistTime"))
            case .rest:
                return TimeInterval(UserDefaults.standard.integer(forKey: "RestTime"))
        }
    }
}
