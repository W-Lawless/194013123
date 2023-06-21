/*
 /// This was a very hard to find example of thorough testing of the Timer class, please leave for future reference
class TimerControllerTests: XCTestCase {

    // MARK - Properties

    var timerController: TimerController!

    // MARK - Setup

    override func setUp() {
        timerController = TimerController(seconds: 1)
    }

    // MARK - Teardown

    override func tearDown() {
        timerController.resetTimer()
        super.tearDown()
    }

    // MARK - Time

    func test_TimerController_DurationInSeconds_IsSet() {
        let expected: TimeInterval = 60
        let timerController = TimerController(seconds: 60)
        XCTAssertEqual(timerController.durationInSeconds, expected, "'durationInSeconds' is not set to correct value.")
    }

    func test_TimerController_DurationInSeconds_IsZeroAfterTimerIsFinished() {
        let numberOfSeconds: TimeInterval = 1
        let durationExpectation = expectation(description: "durationExpectation")
        timerController = TimerController(seconds: numberOfSeconds)
        timerController.startTimer(fireCompletion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + numberOfSeconds, execute: {
            durationExpectation.fulfill()
            XCTAssertEqual(0, self.timerController.durationInSeconds, "'durationInSeconds' is not set to correct value.")
        })
        waitForExpectations(timeout: numberOfSeconds + 1, handler: nil)
    }

    // MARK - Timer State

    func test_TimerController_TimerIsValidAfterTimerStarts() {
        let timerValidityExpectation = expectation(description: "timerValidity")
        timerController.startTimer {
            timerValidityExpectation.fulfill()
            XCTAssertTrue(self.timerController.isTimerValid, "Timer is invalid.")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_TimerController_TimerIsInvalidAfterTimerIsPaused() {
        let timerValidityExpectation = expectation(description: "timerValidity")
        timerController.startTimer {
            self.timerController.pauseTimer()
            timerValidityExpectation.fulfill()
            XCTAssertFalse(self.timerController.isTimerValid, "Timer is valid")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_TimerController_TimerIsInvalidAfterTimerIsReset() {
        let timerValidityExpectation = expectation(description: "timerValidity")
        timerController.startTimer {
            self.timerController.resetTimer()
            timerValidityExpectation.fulfill()
            XCTAssertFalse(self.timerController.isTimerValid, "Timer is valid")
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

}
*/


/*
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
*/
