import SwiftUI
import Combine
import SwiftData
import os

enum SessionState {
    case countdown
    case breathing
    case pausedDuringCountdown
    case paused
    case completed
}

enum BreathingPhase: String {
    case inhale
    case holdIn
    case exhale
    case holdOut
    
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .inhale: "Inhale"
        case .holdIn: "Hold (In)"
        case .exhale: "Exhale"
        case .holdOut: "Hold (Out)"
        }
    }
}

@MainActor
final class PracticeViewModel: ObservableObject {
    
    let kind: PracticeKind
    
    @Published var sessionState: SessionState = .countdown
    @Published var countdownCount: Int = 3
    
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var currentCycle: Int = 1
    
    @Published var totalSecondsRemaining: Int = 0
    @Published var phaseProgress: Double = 0.0
    
    private var countdownTicks: Double = 0.0
    private var timer: AnyCancellable?
    private var totalTimeRemainingTicks: Double = 0.0
    private var phaseSecondsElapsed: Double = 0.0
    private let timeStep: Double = 0.02
    
    private var inhaleDuration: Double = 4.0
    private var holdInDuration: Double = 0.0
    private var exhaleDuration: Double = 8.0
    private var holdOutDuration: Double = 0.0
    
    private(set) var maxCycles: Int = 1
    
    private static let logger = Logger(subsystem: "com.ggs.GGSBreath", category: "PracticeViewModel")
    
    init(kind: PracticeKind) {
        self.kind = kind
        applyPracticeMetrics()
    }
    
    private func applyPracticeMetrics() {
        let pattern = kind.pattern
        inhaleDuration = pattern.inhale
        holdInDuration = pattern.holdIn
        exhaleDuration = pattern.exhale
        holdOutDuration = pattern.holdOut
        maxCycles = pattern.maxCycles
        totalTimeRemainingTicks = pattern.totalSeconds
        totalSecondsRemaining = Int(ceil(totalTimeRemainingTicks))
    }
    
    private func resetSessionProgress() {
        applyPracticeMetrics()
        sessionState = .countdown
        countdownCount = 3
        countdownTicks = 0.0
        currentPhase = .inhale
        phaseSecondsElapsed = 0.0
        currentCycle = 1
        phaseProgress = 0.0
    }
    
    func startSession() {
        timer?.cancel()
        timer = Timer.publish(every: timeStep, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.gameTick()
            }
    }
    
    func pauseSession() {
        guard sessionState == .countdown || sessionState == .breathing else { return }
        
        if sessionState == .countdown {
            sessionState = .pausedDuringCountdown
        } else {
            sessionState = .paused
        }
        timer?.cancel()
        HapticManager.shared.triggerImpact(style: .light)
    }
    
    func resumeSession() {
        guard sessionState == .paused || sessionState == .pausedDuringCountdown else { return }
        
        if sessionState == .pausedDuringCountdown {
            sessionState = .countdown
        } else {
            sessionState = .breathing
        }
        startSession()
        HapticManager.shared.triggerImpact(style: .light)
    }
    
    func restartSession() {
        timer?.cancel()
        resetSessionProgress()
        startSession()
        HapticManager.shared.triggerImpact(style: .medium)
    }
    
    func endSession() {
        timer?.cancel()
        timer = nil
    }
    
    func handleScenePhase(_ phase: ScenePhase) {
        guard phase == .background else { return }
        pauseSession()
    }
    
    func saveSession(context: ModelContext) {
        let newRecord = BreathingHistory(
            durationInMinutes: kind.durationMinutes,
            practiceTitle: kind.rawValue
        )
        
        context.insert(newRecord)
        
        do {
            try context.save()
        } catch {
            Self.logger.error("Failed to save session: \(error.localizedDescription)")
        }
    }
    
    private func gameTick() {
        switch sessionState {
        case .countdown:
            tickCountdown()
        case .breathing:
            tickBreathing()
        case .paused, .pausedDuringCountdown, .completed:
            break
        }
    }
    
    private func tickCountdown() {
        countdownTicks += timeStep
        guard countdownTicks >= 1.0 else { return }
        
        if countdownCount > 1 {
            countdownCount -= 1
            countdownTicks = 0.0
            HapticManager.shared.triggerImpact(style: .light)
        } else {
            sessionState = .breathing
            countdownCount = 0
            phaseSecondsElapsed = 0.0
            phaseProgress = 0.0
            currentPhase = .inhale
            HapticManager.shared.triggerImpact(style: .medium)
        }
    }
    
    private func tickBreathing() {
        if totalTimeRemainingTicks > timeStep {
            totalTimeRemainingTicks -= timeStep
        } else {
            totalTimeRemainingTicks = 0.0
        }
        totalSecondsRemaining = Int(ceil(totalTimeRemainingTicks))
        
        phaseSecondsElapsed += timeStep
        let targetDuration = currentPhaseDuration()
        
        phaseProgress = min(phaseSecondsElapsed / targetDuration, 1.0)
        
        if phaseSecondsElapsed >= targetDuration {
            phaseSecondsElapsed = 0.0
            phaseProgress = 0.0
            goToNextPhase()
        }
    }
    
    private func currentPhaseDuration() -> Double {
        switch currentPhase {
        case .inhale: inhaleDuration
        case .holdIn: holdInDuration
        case .exhale: exhaleDuration
        case .holdOut: holdOutDuration
        }
    }
    
    private func goToNextPhase() {
        HapticManager.shared.triggerImpact(style: .medium)
        
        switch currentPhase {
        case .inhale:
            currentPhase = holdInDuration > 0 ? .holdIn : .exhale
        case .holdIn:
            currentPhase = .exhale
        case .exhale:
            if holdOutDuration > 0 {
                currentPhase = .holdOut
            } else {
                advanceCycle()
            }
        case .holdOut:
            advanceCycle()
        }
    }
    
    private func advanceCycle() {
        if currentCycle < maxCycles {
            currentCycle += 1
            currentPhase = .inhale
        } else {
            sessionState = .completed
            timer?.cancel()
            timer = nil
            HapticManager.shared.triggerImpact(style: .heavy)
        }
    }
    
    func formatTotalTime() -> String {
        let minutes = totalSecondsRemaining / 60
        let seconds = totalSecondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
