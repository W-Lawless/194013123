//
//  MockTimer.swift
//  Sandbox-Tests
//
//  Created by Lawless on 11/17/22.
//

import Foundation

internal final class TimerController {

    // MARK: - Properties

    private var timer = Timer()
    private let timerIntervalInSeconds = TimeInterval(1)
    internal private(set) var durationInSeconds: TimeInterval
    internal var isTimerValid: Bool {
        return timer.isValid
    }

    // MARK: - Initialization

    internal init(seconds: Double) {
        durationInSeconds = TimeInterval(seconds)
    }

    // MARK: - Timer Control

    internal func startTimer(fireCompletion: (() -> Void)?) {
        timer = Timer.scheduledTimer(withTimeInterval: timerIntervalInSeconds, repeats: true, block: { [unowned self] _ in
            self.durationInSeconds -= 1
            fireCompletion?()
        })
    }

    internal func pauseTimer() {
        invalidateTimer()
    }

    internal func resetTimer() {
        invalidateTimer()
        durationInSeconds = 0
    }

    // MARK: - Helpers

    private func invalidateTimer() {
        timer.invalidate()
    }

}
