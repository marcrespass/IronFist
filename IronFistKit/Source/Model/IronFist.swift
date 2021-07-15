//
//  IronFist.swift
//
//  Created by Marc Respass on 5/31/21.
//

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
