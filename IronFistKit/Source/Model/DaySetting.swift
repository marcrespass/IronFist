//
//  DaySetting.swift
//  IronFistKit
//
//  Created by Marc Respass on 8/12/21.
//

import Foundation

public struct DaySetting: Identifiable, Hashable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    public static let days: [DaySetting] = [
        DaySetting(id: 1, name: "Sunday"),
        DaySetting(id: 2, name: "Monday"),
        DaySetting(id: 3, name: "Tuesday"),
        DaySetting(id: 4, name: "Wednesday"),
        DaySetting(id: 5, name: "Thursday"),
        DaySetting(id: 6, name: "Friday"),
        DaySetting(id: 7, name: "Saturday")
    ]
}
