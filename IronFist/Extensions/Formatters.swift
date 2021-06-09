//
//  Formatters.swift
//  CombineTimer
//
//  Created by Marc Respass on 6/1/21.
//

import Foundation

public enum Formatters {
    static var decimalFormatter: NumberFormatter {
        let it = NumberFormatter()
        it.numberStyle = .decimal
        it.minimumIntegerDigits = 1
        it.minimumFractionDigits = 1
        it.maximumFractionDigits = 1
        return it
    }

    static var plainFormatter: NumberFormatter {
        let it = NumberFormatter()
        it.numberStyle = .none
        it.roundingMode = .ceiling
        it.minimumIntegerDigits = 1
        it.minimumFractionDigits = 0
        it.maximumFractionDigits = 0
        return it
    }

    static var fractionFormatter: NumberFormatter {
        let it = NumberFormatter()
        it.numberStyle = .decimal
        it.maximumIntegerDigits = 0
        it.minimumFractionDigits = 1
        it.maximumFractionDigits = 1
        return it
    }
}
