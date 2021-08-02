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
    public let motivation: String

    public func spokenText(title: Bool, instruction: Bool, motivation: Bool) -> String {
        var text = "\(self.id). "
        if title { text += "\(self.title). " }
        if instruction { text += "\(self.instruction) " }
        if motivation { text += "\(self.motivation)" }
        text += " Begin."
        return text
    }
}

public extension IronFist {
    static func loadData() -> [IronFist] {
        guard let frameworkBundle = Bundle(identifier: "com.iliosinc.IronFistKit") else {
            fatalError("Framework with identifier com.iliosinc.IronFistKit was not found!")
        }
        let array: [IronFist] = frameworkBundle.decode(from: "IronFist.json")
        if ProcessInfo.processInfo.arguments.contains("-testingMode") {
            return Array(array.prefix(2))
        }
        return array
    }
}
