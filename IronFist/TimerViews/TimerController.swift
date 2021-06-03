//
//  Controller.swift
//  CombineTimer
//
//  Created by Marc Respass on 5/31/21.
//

import Foundation
import Combine
import CoreGraphics

public final class TimerController: NSObject, ObservableObject {
    @Published var countdownString: String = "0"
    @Published var tenths: CGFloat = 1
    @Published var state: CircleState = .fist  {
        didSet {
            self.configureTimer()
        }
    }

    private var timerSeconds: TimeInterval = 0
    private var stopTime = Date()
    private var cancellable: Cancellable?
    private var cancellableTimerPublisher: Cancellable?
    private var timerPublisher: Timer.TimerPublisher
    private var displayFormatter = Formatters.plainFormatter

    public override init() {
        self.timerPublisher = Timer.publish(every: 0.1, on: RunLoop.main, in: .common)
        super.init()
        self.configureTimer()
    }

    private func configureTimer(showTenths: Bool = false) {
        self.timerSeconds = self.state.timerValue
        self.tenths = 1
        self.displayFormatter = showTenths ? Formatters.decimalFormatter : Formatters.plainFormatter
        self.countdownString = self.displayFormatter.string(from: NSNumber(value: self.timerSeconds)) ?? "error"
    }

    public func startTimer() {
        let startTime = Date()
        self.stopTime = startTime.addingTimeInterval(self.state.timerValue)

        self.cancellable = self.timerPublisher
            .map { date in
                return date.distance(to: self.stopTime)
            }
            .sink { value in
                self.timerSeconds = value
                if self.timerSeconds > 0 {
                    let fraction = self.timerSeconds.truncatingRemainder(dividingBy: 1)
                    self.tenths = CGFloat(fraction)
                    let countdownNumber = NSNumber(value: self.timerSeconds)
                    self.countdownString = self.displayFormatter.string(from: countdownNumber) ?? "error"
                } else {
                    self.cancelTimers()
                    if self.state == .fist {
                        self.state = .rest
                        self.startTimer()
                    } else {
                        self.state = .fist
                    }
                }
            }
        self.cancellableTimerPublisher = self.timerPublisher.connect()
    }

    public func stopTimer() {
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
