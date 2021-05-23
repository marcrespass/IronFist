// Created by Marc Respass on 12/28/17.
// Copyright © 2017 ILIOS Inc. All rights reserved.
// Swift version: 4.0 – macOS: 10.12

import Foundation

public struct IronFist: Codable, Hashable, Identifiable {
    public var id: Int
    public let title: String
    public let exercise: String

    public var exerciseTruncated: String {
        "\(self.exercise.prefix(50))…"
    }

    public var spokenText: String {
        "\(self.id). \(self.title). \(self.exercise). Begin."
    }
}
