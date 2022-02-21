//
//  IronFistKitTests.swift
//  IronFistKitTests
//
//  Created by Marc Respass on 7/8/21.
//

import XCTest
import AVFoundation
@testable import IronFistKit

struct VoiceMenuItem: Equatable {
    struct VoiceLocale {
        let identifier: String
        var language: String {
            if let it = identifier.split(separator: "-").first {
                return String(it)
            }
            return ""
        }
        var country: String {
            if let it = identifier.split(separator: "-").last {
                return String(it)
            }
            return ""
        }
    }
    let title: String
    let isHeader: Bool
    let index: Int

    init(title: String, index: Int, isHeader: Bool = false) {
        self.title = title.capitalized
        self.index = index
        self.isHeader = isHeader
    }

    init(identifier: VoiceLocale, index: Int, isHeader: Bool = false) {
        let locale = NSLocale(localeIdentifier: String("\(identifier.language)_\(identifier.country)"))
        let languageName = locale.displayName(forKey: NSLocale.Key.languageCode, value: identifier.language)
        let countryName = locale.displayName(forKey: NSLocale.Key.countryCode, value: identifier.country)!
        self.title = "\(languageName?.capitalized ?? "Language") - \(countryName)"
        self.index = index
        self.isHeader = isHeader
    }
}

class IronFistKitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasIronFists() throws {
        let it = IronFistController()
        XCTAssertNotNil(it.ironFists)
    }

    func testIronFistCountIs12() throws {
        let it = IronFistController()
        XCTAssertEqual(it.ironFists.count, 2)
    }

    func testVoices() {
        XCTAssertFalse(self.configureVoices().isEmpty)
    }

    func testVoicesMenus() {
        let them = self.setupVoicesMenu()
        XCTAssertFalse(them.isEmpty)
    }

    private func configureVoices() -> [AVSpeechSynthesisVoice] {
        let voices = AVSpeechSynthesisVoice.speechVoices()

        let filtered = voices.filter { voice in
            voice.language.hasPrefix("en") || voice.language.hasPrefix("es")
        }.sorted { $0.language < $1.language }

        return filtered
    }

    private func setupVoicesMenu() -> [VoiceMenuItem] {
        let voices = self.configureVoices()
        var voiceMenuItems: [VoiceMenuItem] = []

        for (index, voice) in voices.enumerated() {
            let voiceLocale = VoiceMenuItem.VoiceLocale(identifier: voice.language)
            let countryItem = VoiceMenuItem(identifier: voiceLocale, index: index, isHeader: true)

            if !voiceMenuItems.contains(where: { vmi in
                vmi.title == voiceLocale.language
            }) {
                voiceMenuItems.append(countryItem)
                print(countryItem.title)
            }
            let title = voice.name
            let voiceMenuItem = VoiceMenuItem(title: title, index: index)
            voiceMenuItems.append(voiceMenuItem)
            print(voiceMenuItem.title)
        }

        return voiceMenuItems
    }
}
