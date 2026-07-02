import XCTest
import SwiftUI
import SwiftData
@testable import GGSBreath

@MainActor
final class PracticeViewModelTests: XCTestCase {
    
    // MARK: - Initial state
    func test_initialState_isCorrect_forEachKind() async throws  {
        for kind in PracticeKind.allCases {
            let vm = PracticeViewModel(kind: kind)
            
            XCTAssertEqual(vm.sessionState, .countdown, "Kind: \(kind)")
            XCTAssertEqual(vm.countdownCount, 3, "Kind: \(kind)")
            XCTAssertEqual(vm.currentPhase, .inhale, "Kind: \(kind)")
            XCTAssertEqual(vm.currentCycle, 1, "Kind: \(kind)")
            XCTAssertEqual(vm.phaseProgress, 0.0, "Kind: \(kind)")
            XCTAssertEqual(vm.maxCycles, kind.pattern.maxCycles, "Kind: \(kind)")
            XCTAssertEqual(vm.totalSecondsRemaining, Int(kind.pattern.totalSeconds), "Kind: \(kind)")
        }
    }
    
    // MARK: - pauseSession() state transitions
    func test_pauseSession_fromCountdown_movesToPausedDuringCountdown() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.startSession()
        
        vm.pauseSession()
        
        XCTAssertEqual(vm.sessionState, .pausedDuringCountdown)
        vm.endSession()
    }
    
    func test_pauseSession_fromBreathing_movesToPaused() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.sessionState = .breathing
        
        vm.pauseSession()
        
        XCTAssertEqual(vm.sessionState, .paused)
    }
    
    func test_pauseSession_fromCompleted_isIgnored() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.sessionState = .completed
        
        vm.pauseSession()
        
        XCTAssertEqual(vm.sessionState, .completed)
    }
    
    // MARK: - resumeSession() state transitions
    func test_resumeSession_fromPausedDuringCountdown_returnsToCountdown() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.sessionState = .pausedDuringCountdown
        
        vm.resumeSession()
        
        XCTAssertEqual(vm.sessionState, .countdown)
        vm.endSession()
    }
    
    func test_resumeSession_fromPaused_returnsToBreathing() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.sessionState = .paused
        
        vm.resumeSession()
        
        XCTAssertEqual(vm.sessionState, .breathing)
        vm.endSession()
    }
    
    func test_resumeSession_fromNonPausedState_isIgnored() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.sessionState = .completed
        
        vm.resumeSession()
        
        XCTAssertEqual(vm.sessionState, .completed)
    }
    
    // MARK: - restartSession()
    func test_restartSession_resetsAllProgress() async throws {
        let vm = PracticeViewModel(kind: .calm)
        
        vm.sessionState = .breathing
        vm.currentCycle = 3
        vm.currentPhase = .exhale
        vm.countdownCount = 1
        vm.phaseProgress = 0.5
        
        vm.restartSession()
        
        XCTAssertEqual(vm.sessionState, .countdown)
        XCTAssertEqual(vm.countdownCount, 3)
        XCTAssertEqual(vm.currentCycle, 1)
        XCTAssertEqual(vm.currentPhase, .inhale)
        XCTAssertEqual(vm.phaseProgress, 0.0)
        XCTAssertEqual(vm.totalSecondsRemaining, Int(PracticeKind.calm.pattern.totalSeconds))
        
        vm.endSession()
    }
    
    // MARK: - Timer-driven behavior (real time)
    func test_countdownTicksDown_overRealTime() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.startSession()
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertEqual(vm.countdownCount, 2)
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertEqual(vm.countdownCount, 1)
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertEqual(vm.sessionState, .breathing)
        XCTAssertEqual(vm.countdownCount, 0)
        XCTAssertEqual(vm.currentPhase, .inhale)
        
        vm.endSession()
    }
    
    func test_pauseDuringCountdown_stopsTicking() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.startSession()
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertEqual(vm.countdownCount, 2)
        
        vm.pauseSession()
        XCTAssertEqual(vm.sessionState, .pausedDuringCountdown)
        
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertEqual(vm.countdownCount, 2)
        
        vm.endSession()
    }
    
    // MARK: - handleScenePhase(_:)
    func test_handleScenePhase_background_pausesActiveSession() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.startSession()
        
        vm.handleScenePhase(.background)
        
        XCTAssertEqual(vm.sessionState, .pausedDuringCountdown)
        vm.endSession()
    }
    
    func test_handleScenePhase_active_doesNotPause() async throws {
        let vm = PracticeViewModel(kind: .energy)
        vm.startSession()
        
        vm.handleScenePhase(.active)
        
        XCTAssertEqual(vm.sessionState, .countdown)
        vm.endSession()
    }
    
    // MARK: - formatTotalTime()
    func test_formatTotalTime_formatsMinutesAndSeconds() async throws {
        let calmVM = PracticeViewModel(kind: .calm)
        XCTAssertEqual(calmVM.formatTotalTime(), "05:04")
        
        let energyVM = PracticeViewModel(kind: .energy)
        XCTAssertEqual(energyVM.formatTotalTime(), "03:00")
    }
    
    // MARK: - saveSession(context:) — SwiftData persistence
    func test_saveSession_insertsRecordWithCorrectData() async throws  {
        let schema = Schema([BreathingHistory.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [config])
        let context = ModelContext(container)
        
        let vm = PracticeViewModel(kind: .focus)
        vm.saveSession(context: context)
        
        let results = try context.fetch(FetchDescriptor<BreathingHistory>())
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.durationInMinutes, PracticeKind.focus.durationMinutes)
        XCTAssertEqual(results.first?.practiceTitle, PracticeKind.focus.rawValue)
    }
}
