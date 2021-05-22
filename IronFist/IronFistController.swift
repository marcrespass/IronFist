//
//  IronFistController.swift
//  IronFist
//
//  Created by Marc Respass on 5/21/21.
//

import Foundation
import AVFoundation

public final class IronFistController: NSObject, ObservableObject {
    static let timeIntervalValue = 3.0

    static func loadFromBundle() -> [IronFist] {
        let array: [IronFist] = Bundle(for: Self.self).decode(from: "IronFistTest.json")
        return array
    }
    // MARK: - Speech Properties
    let speechSynthesizer = AVSpeechSynthesizer()
    let soStrongSynthesizer = AVSpeechSynthesizer()
    var speechVoice: AVSpeechSynthesisVoice?
    @Published var timerInterval: TimeInterval = 0
    @Published var selectedIronFist: IronFist?

    weak var timer: Timer?

    public let ironFists: [IronFist]
    var playingIndex = 0

    override public init() {
        let array = IronFistController.loadFromBundle()
        self.ironFists = array
        super.init()

        self.speechSynthesizer.delegate = self
        self.soStrongSynthesizer.delegate = self
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
        self.speakCurrentItem()
    }

    func stopIronFist(_ sender: Any) {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
        self.timer?.invalidate()
        self.timer = nil
        //        self.delegate?.stopPlaying()
    }

    private func speakCurrentItem() {
        guard let it = self.selectedIronFist else { return }
        let text = it.spokenText
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = self.speechVoice
        debugPrint("Speaking: \(text)")
        self.speechSynthesizer.speak(speechUtterance)
    }

    private func startTimer() {
        self.timerInterval = IronFistController.timeIntervalValue

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

        let speechUtterance = AVSpeechUtterance(string: "Wow. You are so strong.")
        speechUtterance.voice = self.speechVoice
        self.soStrongSynthesizer.speak(speechUtterance)
    }

    private func nextItem() {
        self.playingIndex += 1
        if self.playingIndex >= self.ironFists.count {
            self.playingIndex = 0
            self.selectedIronFist = nil
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
            self.nextItem()
        } else {
            self.startTimer()
        }
    }
}
