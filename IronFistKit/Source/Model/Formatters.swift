//
//  Formatters.swift
//
//  Created by Marc Respass on 6/1/21.
//

import Foundation

public enum Formatters {
    static var plainFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.roundingMode = .ceiling
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
}
