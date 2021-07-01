// Created by Marc Respass on 12/28/17.
// Copyright © 2017 ILIOS Inc. All rights reserved.
// Swift version: 4.0 – macOS: 10.12

import Foundation

public struct IronFist: Codable, Hashable, Identifiable {
    public var id: Int
    public let title: String
    public let instruction: String

    public var titleInstructionText: String {
        "\(self.id). \(self.title). \(self.instruction). Begin."
    }

    public var titleText: String {
        "\(self.id). \(self.title). Begin."
    }
}
