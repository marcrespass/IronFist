//
//  Controller.swift
//
//  Created by Marc Respass on 5/31/21.
//

import Foundation
import Combine
import CoreGraphics
import AVFoundation
import UIKit
import SwiftUI

/// Data is read-only and loaded from a JSON in the app bundle
/// This object is the AVSpeechSynthesizerDelegate
/// It manages a timer, manages speech, and manages the current selection
public final class IronFistController: NSObject, ObservableObject {
    // MARK: - Private Static Properties
    private static func loadIronFistsFromBundle() -> [IronFist] {
        let array: [IronFist] = Bundle(for: Self.self).decode(from: "IronFist.json")
        if ProcessInfo.processInfo.arguments.contains("-testingMode") {
            return Array(array.prefix(3))
        }
        return array
    }

    public static var ironFistSample: IronFist {
        guard let sample = loadIronFistsFromBundle().first else { fatalError("There must be one but there isn't") }
        return sample
    }

    // MARK: - Published Properties
    @Published public var fistTime: Int
    @Published public var restTime: Int
    @Published public var speakTitle: Bool
    @Published public var speakDescription: Bool
    @Published public var speakMotivation: Bool
    @Published private (set) public var selectedIronFist: IronFist?
    @Published private (set) public var countdownString: String = "0"
    @Published private (set) public var tenths: CGFloat = 1
    @Published private (set) public var circleState: CircleState = .waiting {
        didSet {
            self.configureTimer()
        }
    }
    @Published private (set) public var timerRunning = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = timerRunning
        }
    }

    // MARK: - Gettable
    private (set) public var ironFists: [IronFist]
    // MARK: - Timer Properties
    private var timerSeconds: TimeInterval = 0
    private var stopTime = Date()
    private var cancellable: Cancellable?
    // MARK: - Speech Properties
    private var speechVoice: AVSpeechSynthesisVoice?
    private let ironFistSynthesizer = AVSpeechSynthesizer()
    private let soStrongSynthesizer = AVSpeechSynthesizer()
    private let finishSynthesizer = AVSpeechSynthesizer()
    private let finishSpeechUtterance = AVSpeechUtterance(string: "Well done!")
    // MARK: - Other Properties
    private var playingIndex = 0
    private var displayFormatter = Formatters.plainFormatter

    override public init() {
        self.ironFists = IronFistController.loadIronFistsFromBundle()
        self.fistTime = UserDefaults.standard.integer(forKey: Constants.kFistTime)
        self.restTime = UserDefaults.standard.integer(forKey: Constants.kRestTime)
        self.speakTitle = UserDefaults.standard.bool(forKey: Constants.kSpeakTitle)
        self.speakDescription = UserDefaults.standard.bool(forKey: Constants.kSpeakDescription)
        self.speakMotivation = UserDefaults.standard.bool(forKey: Constants.kSpeakMotivation)

        super.init()
        self.selectedIronFist = self.ironFists[self.playingIndex]

        self.configureTimer()
        self.configureSpeech()
    }

    // MARK: - Public methods
    public func buttonLabel() -> Text {
        Text(self.timerRunning ? "Stop" : "Begin")
            .fontWeight(.bold)
            .font(.title)
    }

    public func ready() {
        self.playingIndex = 0
        self.selectedIronFist = self.ironFists[self.playingIndex]
    }

    public func toggle() {
        if self.timerRunning {
            self.stop()
            self.ready()
        } else {
            self.start()
        }
    }

    public func start() {
        self.ready()
        self.configureTimer()
        self.timerRunning = true
        self.handleCurrentItem()
    }

    public func stop() {
        self.timerRunning = false
        self.timerSeconds = 0
        self.cancelTimers()

        self.ironFistSynthesizer.stopSpeaking(at: .immediate)
        self.soStrongSynthesizer.stopSpeaking(at: .immediate)
        self.finishSynthesizer.stopSpeaking(at: .immediate)

        self.ironFistSynthesizer.delegate = nil
        self.soStrongSynthesizer.delegate = nil
        self.finishSynthesizer.delegate = nil

        self.circleState = .waiting
        self.playingIndex = 0
        self.selectedIronFist = nil
    }

    public func saveSettings() {
        UserDefaults.standard.set(self.fistTime, forKey: Constants.kFistTime)
        UserDefaults.standard.set(self.restTime, forKey: Constants.kRestTime)
        UserDefaults.standard.set(self.speakTitle, forKey: Constants.kSpeakTitle)
        UserDefaults.standard.set(self.speakDescription, forKey: Constants.kSpeakDescription)
        UserDefaults.standard.set(self.speakMotivation, forKey: Constants.kSpeakMotivation)
    }
}

// MARK: - Private methods
extension IronFistController {
    private func configureSpeech() {
        let englishVoices = AVSpeechSynthesisVoice.speechVoices().filter { voice in
            return voice.language == "en-US" && voice.gender == .female
        }
        self.speechVoice = englishVoices.first

        self.finishSpeechUtterance.voice = self.speechVoice
    }

    private func configureTimer() {
        self.timerSeconds = self.circleState.timerValue
        self.tenths = 1
        self.displayFormatter = Formatters.plainFormatter
        self.countdownString = self.displayFormatter.string(from: NSNumber(value: self.timerSeconds)) ?? "error"
    }

    private func advanceItem() {
        self.playingIndex += 1

        if self.playingIndex < self.ironFists.count {
            self.selectedIronFist = self.ironFists[self.playingIndex]
        }
    }

    private func configureNextItem() {
        if self.playingIndex >= self.ironFists.count {
            self.finishSynthesizer.speak(finishSpeechUtterance)
            self.finishSynthesizer.delegate = self
        } else {
            self.handleCurrentItem()
        }
    }

    private func handleCurrentItem() {
        guard let ironFist = self.selectedIronFist else { return }

        let text = self.speakTitle ? ironFist.titleInstructionText : ironFist.titleText
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = self.speechVoice
        self.ironFistSynthesizer.speak(speechUtterance)
        self.ironFistSynthesizer.delegate = self
    }

    private func startTimer() {
        let startTime = Date()
        self.stopTime = startTime.addingTimeInterval(self.circleState.timerValue)

        self.cancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .map { date in
                return date.distance(to: self.stopTime)
            }
            .sink { [weak self] timerTimeInterval in
                guard let strongSelf = self else { return }
                strongSelf.timerSeconds = timerTimeInterval
                if strongSelf.timerSeconds > 0 {
                    let fraction = strongSelf.timerSeconds.truncatingRemainder(dividingBy: 1)
                    strongSelf.tenths = CGFloat(fraction)
                    strongSelf.countdownString = strongSelf.displayFormatter.string(from: NSNumber(value: strongSelf.timerSeconds)) ?? "error"
                } else {
                    strongSelf.cancelTimers()
                    if strongSelf.circleState == .fist {
                        strongSelf.circleState = .rest

                        let text = strongSelf.speakTitle ? "Wow. You are so strong. Rest." : "Rest."
                        let speechUtterance = AVSpeechUtterance(string: text)
                        speechUtterance.voice = strongSelf.speechVoice
                        strongSelf.soStrongSynthesizer.speak(speechUtterance)
                        strongSelf.soStrongSynthesizer.delegate = self
                        strongSelf.advanceItem()
                    } else {
                        strongSelf.circleState = .waiting
                        strongSelf.configureNextItem()
                    }
                }
            }
    }

    private func cancelTimers() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension IronFistController: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish: AVSpeechUtterance) {
        if synthesizer == self.soStrongSynthesizer {
            self.circleState = .rest
            self.startTimer()
        } else if synthesizer == self.finishSynthesizer {
            self.stop()
        } else {
            self.circleState = .fist
            self.startTimer()
        }
    }
}
