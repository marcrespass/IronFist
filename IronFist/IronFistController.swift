//
//  IronFistController.swift
//  IronFist
//
//  Created by Marc Respass on 5/21/21.
//

import Foundation
import AVFoundation

public final class IronFistController: NSObject, ObservableObject {
    // MARK: - Static Properties
    static let timeIntervalValue = 3.0 // TESTING

    static func loadFromBundle() -> [IronFist] {
        let array: [IronFist] = Bundle(for: Self.self).decode(from: "IronFistTest.json") // TESTING
        return array
    }
    // MARK: - Speech Properties
    var speechVoice: AVSpeechSynthesisVoice?
    let speechSynthesizer = AVSpeechSynthesizer()
    let soStrongSynthesizer = AVSpeechSynthesizer()
    let finishSynthesizer = AVSpeechSynthesizer()
    let soStrongSpeechUtterance = AVSpeechUtterance(string: "Wow. You are so strong. Rest.")
    let finishSpeechUtterance = AVSpeechUtterance(string: "Well done!")

    // MARK: - Published Properties
    @Published var timerInterval: TimeInterval = 0
    @Published var selectedIronFist: IronFist?
    @Published var fistTime: Int
    @Published var restTime: Int
    @Published var timerRunning = false

    // MARK: - Properties
    weak var timer: Timer?
    private (set) var ironFists: [IronFist]
    private var playingIndex = 0

    // MARK: - Init
    override public init() {
        let array = IronFistController.loadFromBundle()
        self.ironFists = array
        let ft = UserDefaults.standard.integer(forKey: "FistTime")
        debugPrint("FistTime: \(ft)")
        self.fistTime = ft
        let rt = UserDefaults.standard.integer(forKey: "RestTime")
        debugPrint("RestTime: \(rt)")
        self.restTime = rt
        
        super.init()

        soStrongSpeechUtterance.voice = self.speechVoice

        self.speechSynthesizer.delegate = self
        self.soStrongSynthesizer.delegate = self
        self.finishSynthesizer.delegate = self
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Nicky" {
                debugPrint("ID: \(voice.identifier) | Name: \(voice.name) | Quality:  \(voice.quality)")
                self.speechVoice = voice
                break
            }
        }
    }

    func startIronFist() {
        self.playingIndex = 0
        self.selectedIronFist = self.ironFists[self.playingIndex]
        self.timerRunning = true
        self.speakCurrentItem()
    }

    func stopIronFist(_ sender: Any) {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
        self.timer?.invalidate()
        self.timer = nil
    }

    func saveSettings() {
        debugPrint("FistTime: \(self.fistTime)")
        debugPrint("RestTime: \(self.restTime)")

        UserDefaults.standard.set(self.fistTime, forKey: "FistTime")
        UserDefaults.standard.set(self.restTime, forKey: "RestTime")
    }
}

// MARK: - Private methods
extension IronFistController {
    private func speakCurrentItem() {
        guard let ironFist = self.selectedIronFist else { return }
        let text = ironFist.spokenText
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = self.speechVoice
        debugPrint("Speaking: \(ironFist.title)")
        self.speechSynthesizer.speak(speechUtterance)
    }

    private func startFist() {
        self.timerInterval = TimeInterval(self.fistTime)
        self.timerRunning = true

        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timerInterval -= 1
            if self.timerInterval <= 0 {
                self.finishCurrentItem()
            }
        })
    }

    private func finishCurrentItem() {
        self.timer?.invalidate()
        self.timer = nil
        self.soStrongSynthesizer.speak(soStrongSpeechUtterance)
    }

    private func restHands() {
        self.timerInterval = TimeInterval(self.restTime)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timerInterval -= 1
            if self.timerInterval <= 0 {
                self.timer?.invalidate()
                self.timer = nil

                self.nextItem()
            }
        })
    }

    private func nextItem() {
        self.playingIndex += 1
        if self.playingIndex >= self.ironFists.count {
            self.playingIndex = 0
            self.selectedIronFist = nil
            self.timerRunning = false

            self.finishSynthesizer.speak(finishSpeechUtterance)
        } else {
            self.selectedIronFist = self.ironFists[self.playingIndex]
            self.speakCurrentItem()
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension IronFistController: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish: AVSpeechUtterance) {
        if synthesizer == self.soStrongSynthesizer {
            self.restHands()
        } else if synthesizer == self.finishSynthesizer {
            print("Finished - notify delegate")
        } else {
            self.startFist()
        }
    }
}
