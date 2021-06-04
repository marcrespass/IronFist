//
//  Controller.swift
//  CombineTimer
//
//  Created by Marc Respass on 5/31/21.
//

import Foundation
import Combine
import CoreGraphics
import AVFoundation
import UIKit

public final class TimerController: NSObject, ObservableObject {
    private static func loadIronFistsFromBundle() -> [IronFist] {
        let array: [IronFist] = Bundle(for: Self.self).decode(from: "IronFist.json")
        if ProcessInfo.processInfo.arguments.contains("-testingMode") {
            return Array(array.prefix(3))
        }
        return array
    }

    public static var ironFistSample: IronFist {
        guard let it = loadIronFistsFromBundle().first else { fatalError("There  must be one but there isn't") }
        return it
    }

    // MARK: - Published Properties
    @Published var fistTime: Int
    @Published var restTime: Int
    @Published private (set) var selectedIronFist: IronFist?
    @Published private (set) var countdownString: String = "0"
    @Published private (set) var tenths: CGFloat = 1
    @Published private (set) var state: CircleState = .fist  {
        didSet {
            self.configureTimer()
        }
    }
    @Published private (set) var timerRunning = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = timerRunning
        }
    }

    // MARK: - Gettable
    private (set) var ironFists: [IronFist]

    // MARK: - Timer Properties
    private var playingIndex = 0
    private var timerSeconds: TimeInterval = 0
    private var stopTime = Date()
    private var cancellable: Cancellable?
    private var cancellableTimerPublisher: Cancellable?
    private var timerPublisher: Timer.TimerPublisher
    private var displayFormatter = Formatters.plainFormatter

    // MARK: - Speech Properties
    private var speechVoice: AVSpeechSynthesisVoice?
    private let ironFistSynthesizer = AVSpeechSynthesizer()
    private let soStrongSynthesizer = AVSpeechSynthesizer()
    private let finishSynthesizer = AVSpeechSynthesizer()
    private let soStrongSpeechUtterance = AVSpeechUtterance(string: "Wow. You are so strong. Rest.")
    private let finishSpeechUtterance = AVSpeechUtterance(string: "Well done!")

    public override init() {
        self.timerPublisher = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
        self.ironFists = TimerController.loadIronFistsFromBundle()
        self.fistTime = UserDefaults.standard.integer(forKey: "FistTime")
        self.restTime = UserDefaults.standard.integer(forKey: "RestTime")

        super.init()
        debugPrint("FistTime: \(self.fistTime)")
        debugPrint("RestTime: \(self.restTime)")
        self.configureTimer()

        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Nicky" {
                debugPrint("ID: \(voice.identifier) | Name: \(voice.name) | Quality:  \(voice.quality)")
                self.speechVoice = voice
                break
            }
        }

        // MARK: - Speech setup
        self.ironFistSynthesizer.delegate = self
        self.soStrongSynthesizer.delegate = self
        self.finishSynthesizer.delegate = self
        self.soStrongSpeechUtterance.voice = self.speechVoice
        self.finishSpeechUtterance.voice = self.speechVoice
    }

    // MARK: - Public methods
    public func start() {
        self.timerRunning = true
        self.playingIndex = 0
        self.selectedIronFist = self.ironFists[self.playingIndex]
        self.speakCurrentItem()
    }

    public func stop() {
        self.timerRunning = false
        self.ironFistSynthesizer.stopSpeaking(at: .immediate)
        self.soStrongSynthesizer.stopSpeaking(at: .immediate)
        self.finishSynthesizer.stopSpeaking(at: .immediate)
        self.stopTimer()
        self.playingIndex = 0
        self.selectedIronFist = nil
    }

    public func saveSettings() {
        UserDefaults.standard.set(self.fistTime, forKey: "RiceTime")
        UserDefaults.standard.set(self.restTime, forKey: "RestTime")
    }

    // MARK: - Private methods
    private func nextItem() {
        self.playingIndex += 1

        if self.playingIndex >= self.ironFists.count {
            self.finishSynthesizer.speak(finishSpeechUtterance)
        } else {
            self.selectedIronFist = self.ironFists[self.playingIndex]
            self.speakCurrentItem()
        }
    }

    private func speakCurrentItem() {
        guard let ironFist = self.selectedIronFist else { return }

        let text = ironFist.spokenText
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = self.speechVoice
        debugPrint("Speaking: \(ironFist.title)")
        self.ironFistSynthesizer.speak(speechUtterance)
    }

    private func configureTimer(showTenths: Bool = false) {
        self.timerSeconds = self.state.timerValue
        self.tenths = 1
        self.displayFormatter = showTenths ? Formatters.decimalFormatter : Formatters.plainFormatter
        self.countdownString = self.displayFormatter.string(from: NSNumber(value: self.timerSeconds)) ?? "error"
    }

    private func startTimer() {
        let startTime = Date()
        self.stopTime = startTime.addingTimeInterval(self.state.timerValue)

        self.cancellable = self.timerPublisher
            .map { date in
                return date.distance(to: self.stopTime)
            }
            .sink { [weak self] value in
                guard let strongSelf = self else { return }
                strongSelf.timerSeconds = value
                if strongSelf.timerSeconds > 0 {
                    let fraction = strongSelf.timerSeconds.truncatingRemainder(dividingBy: 1)
                    strongSelf.tenths = CGFloat(fraction)
                    let countdownNumber = NSNumber(value: strongSelf.timerSeconds)
                    strongSelf.countdownString = strongSelf.displayFormatter.string(from: countdownNumber) ?? "error"
                } else {
                    strongSelf.cancelTimers()
                    if strongSelf.state == .fist {
                        strongSelf.state = .rest
                        strongSelf.soStrongSynthesizer.speak(strongSelf.soStrongSpeechUtterance)
                    } else {
                        strongSelf.state = .fist
                        strongSelf.nextItem()
                    }
                }
            }
        self.cancellableTimerPublisher = self.timerPublisher.connect()
    }

    private func stopTimer() {
        self.timerSeconds = 0
        self.cancelTimers()
        self.state = .fist
    }

    private func cancelTimers() {
        self.cancellable = nil
        self.cancellableTimerPublisher?.cancel()
        self.cancellableTimerPublisher = nil
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension TimerController: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish: AVSpeechUtterance) {
        if synthesizer == self.soStrongSynthesizer {
            self.state = .rest
            self.startTimer()
        } else if synthesizer == self.finishSynthesizer {
            debugPrint("Finished - notify delegate")
            self.stop()
        } else {
            self.state = .fist
            self.startTimer()
        }
    }
}
