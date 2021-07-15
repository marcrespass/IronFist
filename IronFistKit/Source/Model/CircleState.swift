//
//  CircleState.swift
//
//  Created by Marc Respass on 6/1/21.
//

import SwiftUI

public enum CircleState: Equatable {
    case fist
    case rest
    case waiting

    public var shadowColor: Color {
        switch self {
            case .fist:
                return Color("shadowColorFist")
            case .rest:
                return Color("shadowColorRest")
            case .waiting:
                return Color("shadowColorWait")
        }
    }

    public var timerCircleColor: Color {
        switch self {
            case .fist:
                return .green
            case .rest:
                return .red
            case .waiting:
                return .yellow
        }
    }

    public var titleColor: Color {
        switch self {
            case .fist:
                return .green
            case .rest, .waiting:
                return .yellow
        }
    }

    public var symbol: String {
        switch self {
            case .fist:
                return "👊"
            case .rest:
                return "🖐"
            case .waiting:
                return "✊"
        }
    }

    public var timerValue: TimeInterval {
        switch self {
            case .fist, .waiting:
                return TimeInterval(UserDefaults.standard.integer(forKey: Constants.kFistTime))
            case .rest:
                return TimeInterval(UserDefaults.standard.integer(forKey: Constants.kRestTime))
        }
    }
}
