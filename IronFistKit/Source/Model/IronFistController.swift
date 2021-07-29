//
//  Controller.swift
//
//  Created by Marc Respass on 5/31/21.
//

import Foundation
import AVFoundation
import Combine
import SwiftUI

/// Data is read-only and loaded from a JSON in the app bundle
/// IronFistController holds the list of IronFist objects and manages the current IronFist
/// it also manages the timer and speech
/// IronFistController is the AVSpeechSynthesizerDelegate
public final class IronFistController: NSObject, ObservableObject {
    // MARK: - Published properties
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
    private let speechVoice: AVSpeechSynthesisVoice?
    private let ironFistSynthesizer = AVSpeechSynthesizer()
    private let soStrongSynthesizer = AVSpeechSynthesizer()
    private let finishSynthesizer = AVSpeechSynthesizer()
    private let finishSpeechUtterance = AVSpeechUtterance(string: "Well done!")
    // MARK: - Other Properties
    private var playingIndex = 0
    private var restText: String {
        if UserDefaults.standard.bool(forKey: Constants.kSpeakDescription) || UserDefaults.standard.bool(forKey: Constants.kSpeakMotivation) {
            return "Wow. You are so strong. Rest."
        }
        return "Rest."
    }

    override public init() {
        func loadIronFistsFromBundle() -> [IronFist] {
            let array: [IronFist] = Bundle(for: Self.self).decode(from: "IronFist.json")
            if ProcessInfo.processInfo.arguments.contains("-testingMode") {
                return Array(array.prefix(2))
            }
            return array
        }

        self.ironFists = loadIronFistsFromBundle()
        // Find the first female US English voice
        let englishVoices = AVSpeechSynthesisVoice.speechVoices().filter { voice in
            voice.language == "en-US" && voice.gender == .female
        }
        self.speechVoice = englishVoices.first
        self.finishSpeechUtterance.voice = self.speechVoice

        super.init()

        self.configureTimer()
    }

    // MARK: - Public methods
    public func stopBeginButtonLabel() -> Text {
        Text(self.timerRunning ? "Stop" : "Begin")
            .fontWeight(.bold)
            .font(.title)
    }

    public func readyTimer() {
        self.playingIndex = 0
        self.selectedIronFist = self.ironFists[self.playingIndex]
    }

    public func toggleTimer() {
        self.readyTimer()
        if self.timerRunning {
            self.stopTimer()
        } else {
            self.readyTimer()
            self.configureTimer()
            self.timerRunning = true
            self.handleCurrentItem()
        }
    }

    public func stopTimer() {
        self.timerRunning = false
        self.timerSeconds = 0
        self.cancelTimers()

        self.ironFistSynthesizer.stopSpeaking(at: .immediate)
        self.soStrongSynthesizer.stopSpeaking(at: .immediate)
        self.finishSynthesizer.stopSpeaking(at: .immediate)

        self.ironFistSynthesizer.delegate = nil
        self.soStrongSynthesizer.delegate = nil
        self.finishSynthesizer.delegate = nil

        self.circleState = .stopped
        self.playingIndex = 0
        self.selectedIronFist = nil
    }
}

// MARK: - Private timer methods
extension IronFistController {
    private func configureTimer() {
        self.timerSeconds = self.circleState.timerValue
        self.tenths = 1
        self.countdownString = Formatters.plainFormatter.string(from: NSNumber(value: self.timerSeconds)) ?? "error"
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

        let speaksMotivation = UserDefaults.standard.bool(forKey: Constants.kSpeakMotivation)
        let speaksDescription = UserDefaults.standard.bool(forKey: Constants.kSpeakDescription)
        let speaksTitle = UserDefaults.standard.bool(forKey: Constants.kSpeakTitle)

        let text = ironFist.spokenText(title: speaksTitle, instruction: speaksDescription, motivation: speaksMotivation)
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = self.speechVoice
        self.ironFistSynthesizer.speak(speechUtterance)
        self.ironFistSynthesizer.delegate = self
    }

    private func createAndPublishTimer() {
        let startTime = Date()
        self.stopTime = startTime.addingTimeInterval(self.circleState.timerValue)

        self.cancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] date -> TimeInterval in
                guard let strongSelf = self else { return 0 }
                return date.distance(to: strongSelf.stopTime)
            }
            .sink { [weak self] timerTimeInterval in
                guard let strongSelf = self else { return }
                
                strongSelf.timerSeconds = timerTimeInterval
                if strongSelf.timerSeconds > 0 {
                    let fraction = strongSelf.timerSeconds.truncatingRemainder(dividingBy: 1)
                    strongSelf.tenths = CGFloat(fraction)
                    strongSelf.countdownString = Formatters.plainFormatter.string(from: NSNumber(value: strongSelf.timerSeconds)) ?? "error"
                } else { // done with timer
                    strongSelf.cancelTimers()
                    if strongSelf.circleState == .fist { // FIST change to REST
                        strongSelf.advanceItem()
                        if strongSelf.playingIndex >= strongSelf.ironFists.count {
                            strongSelf.tenths = CGFloat(0)
                            strongSelf.configureNextItem()
                        } else {
                            strongSelf.circleState = .rest

                            let speechUtterance = AVSpeechUtterance(string: strongSelf.restText)
                            speechUtterance.voice = strongSelf.speechVoice
                            strongSelf.soStrongSynthesizer.speak(speechUtterance)
                            strongSelf.soStrongSynthesizer.delegate = self
                        }
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
            self.createAndPublishTimer()
        } else if synthesizer == self.finishSynthesizer {
            self.stopTimer()
        } else {
            self.circleState = .fist
            self.createAndPublishTimer()
        }
    }
}
